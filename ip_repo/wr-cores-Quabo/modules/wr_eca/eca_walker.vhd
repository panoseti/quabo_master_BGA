--! @file eca_walker.vhd
--! @brief ECA Linked list walker
--! @author Wesley W. Terpstra <w.terpstra@gsi.de>
--!
--! Copyright (C) 2013 GSI Helmholtz Centre for Heavy Ion Research GmbH 
--!
--! This component walks a linked list to produce actions from an event.
--! The list head comes from the binary search of the event table.
--! Each rule matched here adds the ECA tag and calculates the action execution
--! time by adding an offset to the event time.
--!
--------------------------------------------------------------------------------
--! This library is free software; you can redistribute it and/or
--! modify it under the terms of the GNU Lesser General Public
--! License as published by the Free Software Foundation; either
--! version 3 of the License, or (at your option) any later version.
--!
--! This library is distributed in the hope that it will be useful,
--! but WITHOUT ANY WARRANTY; without even the implied warranty of
--! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--! Lesser General Public License for more details.
--!  
--! You should have received a copy of the GNU Lesser General Public
--! License along with this library. If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.eca_internals_pkg.all;

entity eca_walker is
  generic(
    g_log_table_size : natural := 8;
    g_num_channels   : natural := 4);
  port(
    clk_i        : in  std_logic;
    rst_n_i      : in  std_logic;
    -- Feed in an index to scan from search
    b_stb_i      : in  std_logic;
    b_stall_o    : out std_logic;
    b_page_i     : in  std_logic;
    b_first_i    : in  std_logic_vector(g_log_table_size-1 downto 0);
    b1_event_i   : in  t_event; -- all one cycle AFTER the b_stb_i
    b1_param_i   : in  t_param;
    b1_tef_i     : in  t_tef;
    b1_time_i    : in  t_time;
    -- Outputs for the channel queue
    q_channel_o  : out t_channel_array (g_num_channels-1 downto 0);
    -- Write to the table
    t_clk_i      : in  std_logic;
    t_page_i     : in  std_logic;
    t_addr_i     : in  std_logic_vector(g_log_table_size-1 downto 0);
    tw_en_i      : in  std_logic;
    tw_valid_i   : in  std_logic;
    tw_delayed_i : in  std_logic;
    tw_conflict_i: in  std_logic;
    tw_late_i    : in  std_logic;
    tw_early_i   : in  std_logic;
    tw_next_i    : in  std_logic_vector(g_log_table_size-1 downto 0);
    tw_time_i    : in  t_time;
    tw_tag_i     : in  t_tag;
    tw_num_i     : in  t_num;
    tw_channel_i : in  std_logic_vector(f_eca_log2(g_num_channels)-1 downto 0);
    tr_valid_o   : out std_logic;
    tr_delayed_o : out std_logic;
    tr_conflict_o: out std_logic;
    tr_late_o    : out std_logic;
    tr_early_o   : out std_logic;
    tr_next_o    : out std_logic_vector(g_log_table_size-1 downto 0);
    tr_time_o    : out t_time;
    tr_tag_o     : out t_tag;
    tr_num_o     : out t_num;
    tr_channel_o : out std_logic_vector(f_eca_log2(g_num_channels)-1 downto 0));
end eca_walker;

architecture rtl of eca_walker is
  -- Quartus 11+ goes crazy and infers 5 M9Ks in an altshift_taps! Stop it.
  attribute altera_attribute : string; 
  attribute altera_attribute of rtl : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF";
  
  constant c_table_ptr_bits   : natural := g_log_table_size;
  constant c_table_index_bits : natural := c_table_ptr_bits+1;
  constant c_channel_bits     : natural := f_eca_log2(g_num_channels);
  
  subtype t_table_ptr   is std_logic_vector(c_table_ptr_bits  -1 downto 0);
  subtype t_channel_id  is std_logic_vector(c_channel_bits    -1 downto 0);
  
  -- Memory signals
  signal s_mr_valid    : std_logic;
  signal s_mr_delayed  : std_logic;
  signal s_mr_conflict : std_logic;
  signal s_mr_late     : std_logic;
  signal s_mr_early    : std_logic;
  signal s_mr_num      : t_num;
  signal s_mr_next     : t_table_ptr;
  signal s_mr_time     : t_time;
  signal s_mr_tag      : t_tag;
  signal s_mr_channel  : t_channel_id;

  -- Walking registers
  signal r_w_valid : std_logic := '0';
  
  signal r_w_latch : std_logic;
  signal r_w_page  : std_logic;
  signal r_w_event : t_event;
  signal r_w_param : t_param;
  signal r_w_tef   : t_tef;
  signal r_w_time  : t_time;
  
  -- Walking signals
  signal s_w_active : std_logic;
  signal s_w_page   : std_logic;
  signal s_w_valid  : std_logic;
  signal s_w_addr   : t_table_ptr;
  
  -- Adjust registers
  signal r3_a_delayed     : std_logic;
  signal r3_a_conflict    : std_logic;
  signal r3_a_late        : std_logic;
  signal r3_a_early       : std_logic;
  signal r3_a_num         : t_num;
  signal r3_a_event       : t_event;
  signal r3_a_param       : t_param;
  signal r3_a_tag         : t_tag;
  signal r3_a_tef         : t_tef;
  signal r3_a_channel     : t_channel_id;
  signal r3_a_valid       : std_logic;
  
  signal r3_a_event_time  : t_time;
  signal r3_a_offset_time : t_time;
  
  signal r2_a_delayed     : std_logic;
  signal r2_a_conflict    : std_logic;
  signal r2_a_late        : std_logic;
  signal r2_a_early       : std_logic;
  signal r2_a_num         : t_num;
  signal r2_a_event       : t_event;
  signal r2_a_param       : t_param;
  signal r2_a_tag         : t_tag;
  signal r2_a_tef         : t_tef;
  signal r2_a_channel     : t_channel_id;
  signal r2_a_valid       : std_logic;
  
  signal r1_a_delayed     : std_logic;
  signal r1_a_conflict    : std_logic;
  signal r1_a_late        : std_logic;
  signal r1_a_early       : std_logic;
  signal r1_a_num         : t_num;
  signal r1_a_event       : t_event;
  signal r1_a_param       : t_param;
  signal r1_a_tag         : t_tag;
  signal r1_a_tef         : t_tef;
  
  signal r1_a_validv      : std_logic_vector(g_num_channels-1 downto 0);
  
  signal s1_a_action_time : t_time;

  constant c_valid_offset    : natural := 0;
  constant c_delayed_offset  : natural := c_valid_offset+1;
  constant c_conflict_offset : natural := c_delayed_offset+1;
  constant c_late_offset     : natural := c_conflict_offset+1;
  constant c_early_offset    : natural := c_late_offset+1;
  subtype  c_num_range     is natural range c_num_bits      +c_early_offset    downto c_early_offset   +1;
  subtype  c_next_range    is natural range c_table_ptr_bits+c_num_range'left  downto c_num_range'left +1;
  subtype  c_time_range    is natural range c_time_bits     +c_next_range'left downto c_next_range'left+1;
  subtype  c_tag_range     is natural range c_tag_bits      +c_time_range'left downto c_time_range'left+1;
  subtype  c_channel_range is natural range c_channel_bits  +c_tag_range'left  downto c_tag_range'left +1;
  
  subtype  t_table_data_type is std_logic_vector(c_channel_range);
  constant c_table_data_bits : natural := t_table_data_type'left + 1; --'
  
  signal active_r_addr_i : std_logic_vector(c_table_index_bits-1 downto 0);
  signal active_w_addr_i : std_logic_vector(c_table_index_bits-1 downto 0);
  signal active_r_data_o : std_logic_vector(c_table_data_bits -1 downto 0);
  signal active_w_data_i : std_logic_vector(c_table_data_bits -1 downto 0);
  
  signal program_r_addr_i : std_logic_vector(c_table_index_bits-1 downto 0);
  signal program_w_addr_i : std_logic_vector(c_table_index_bits-1 downto 0);
  signal program_r_data_o : std_logic_vector(c_table_data_bits -1 downto 0);
  signal program_w_data_i : std_logic_vector(c_table_data_bits -1 downto 0);
  
begin
  
  active_r_addr_i(s_w_addr'length)   <= s_w_page;
  active_r_addr_i(s_w_addr'range)    <= s_w_addr;
  active_w_addr_i(t_addr_i'length)   <= t_page_i;
  active_w_addr_i(t_addr_i'range)    <= t_addr_i;
  active_w_data_i(c_valid_offset)    <= tw_valid_i;
  active_w_data_i(c_delayed_offset)  <= tw_delayed_i;
  active_w_data_i(c_conflict_offset) <= tw_conflict_i;
  active_w_data_i(c_late_offset)     <= tw_late_i;
  active_w_data_i(c_early_offset)    <= tw_early_i;
  active_w_data_i(c_next_range)      <= tw_next_i;
  active_w_data_i(c_time_range)      <= tw_time_i;
  active_w_data_i(c_tag_range)       <= tw_tag_i;
  active_w_data_i(c_num_range)       <= tw_num_i;
  active_w_data_i(c_channel_range)   <= tw_channel_i;
  s_mr_valid    <= active_r_data_o(c_valid_offset);
  s_mr_delayed  <= active_r_data_o(c_delayed_offset);
  s_mr_conflict <= active_r_data_o(c_conflict_offset);
  s_mr_late     <= active_r_data_o(c_late_offset);
  s_mr_early    <= active_r_data_o(c_early_offset);
  s_mr_next     <= active_r_data_o(c_next_range);
  s_mr_time     <= active_r_data_o(c_time_range);
  s_mr_tag      <= active_r_data_o(c_tag_range);
  s_mr_num      <= active_r_data_o(c_num_range);
  s_mr_channel  <= active_r_data_o(c_channel_range);

  Active : eca_sdp
    generic map(
      g_addr_bits  => c_table_index_bits,
      g_data_bits  => c_table_data_bits,
      g_bypass     => false,
      g_dual_clock => true)
    port map(
      r_clk_i  => clk_i,
      r_addr_i => active_r_addr_i,
      r_data_o => active_r_data_o,
      w_clk_i  => t_clk_i,
      w_addr_i => active_w_addr_i,
      w_en_i   => tw_en_i,
      w_data_i => active_w_data_i);
  
  program_r_addr_i(t_addr_i'length)  <= t_page_i;
  program_r_addr_i(t_addr_i'range)   <= t_addr_i;
  program_w_addr_i(t_addr_i'length)  <= t_page_i;
  program_w_addr_i(t_addr_i'range)   <= t_addr_i;
  program_w_data_i(c_valid_offset)    <= tw_valid_i;
  program_w_data_i(c_delayed_offset)  <= tw_delayed_i;
  program_w_data_i(c_conflict_offset) <= tw_conflict_i;
  program_w_data_i(c_late_offset)     <= tw_late_i;
  program_w_data_i(c_early_offset)    <= tw_early_i;
  program_w_data_i(c_next_range)      <= tw_next_i;
  program_w_data_i(c_time_range)      <= tw_time_i;
  program_w_data_i(c_tag_range)       <= tw_tag_i;
  program_w_data_i(c_num_range)       <= tw_num_i;
  program_w_data_i(c_channel_range)   <= tw_channel_i;

  tr_valid_o    <= program_r_data_o(c_valid_offset);
  tr_delayed_o  <= program_r_data_o(c_delayed_offset);
  tr_conflict_o <= program_r_data_o(c_conflict_offset);
  tr_late_o     <= program_r_data_o(c_late_offset);
  tr_early_o    <= program_r_data_o(c_early_offset);
  tr_next_o     <= program_r_data_o(c_next_range);
  tr_time_o     <= program_r_data_o(c_time_range);
  tr_tag_o      <= program_r_data_o(c_tag_range);
  tr_num_o      <= program_r_data_o(c_num_range);
  tr_channel_o  <= program_r_data_o(c_channel_range);
  
  Program : eca_sdp
    generic map(
      g_addr_bits  => c_table_index_bits,
      g_data_bits  => c_table_data_bits,
      g_bypass     => false,
      g_dual_clock => false)
    port map(
      r_clk_i  => t_clk_i,
      r_addr_i => program_r_addr_i,
      r_data_o => program_r_data_o,
      w_clk_i  => t_clk_i,
      w_addr_i => program_w_addr_i,
      w_en_i   => tw_en_i,
      w_data_i => program_w_data_i);
  
  walk : process(clk_i) is
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        r_w_valid <= '0';
      else
        r_w_valid <= s_w_valid;
      end if;
      
      r_w_page  <= s_w_page;
      
      -- If accepting a new request, latch registers
      -- However, do it one cycle late so as to make fan-out timing better
      r_w_latch <= b_stb_i and not s_w_active;
      if r_w_latch = '1' then
        r_w_event <= b1_event_i;
        r_w_param <= b1_param_i;
        r_w_tef   <= b1_tef_i;
        r_w_time  <= b1_time_i;
      end if;
    end if;
  end process;
  
  s_w_active <= r_w_valid and s_mr_valid;
  s_w_valid  <= s_w_active or b_stb_i;
  s_w_page   <= r_w_page  when s_w_active='1' else b_page_i;
  s_w_addr   <= s_mr_next when s_w_active='1' else b_first_i;
  
  -- Not a register; latency=M9K access
  b_stall_o <= s_w_active;
  
  -- Adjust the timestamp and push out the channels; pipelined:
  -- t3: event(3) param(3) tag(3) tef(3) event_time offset_time valid(3)
  -- t2: event(2) param(2) tag(2) tef(2)    ... pipeline ...    valid(2)
  -- t1: event(1) param(1) tag(1) tef(1)    ... pipeline ...    valid1(*) stall
  -- t0: channel_i.* latched by eca_channel
  adjust : process(clk_i) is
  begin
    if rising_edge(clk_i) then
      -- No reset; logic is acyclic
      
      -- Bypass needed because of delayed fanout register r_w_latch
      if r_w_latch = '1' then
        r3_a_event <= b1_event_i;
        r3_a_param <= b1_param_i;
        r3_a_tef   <= b1_tef_i;
        r3_a_event_time  <= b1_time_i;
      else
        r3_a_event <= r_w_event;
        r3_a_param <= r_w_param;
        r3_a_tef   <= r_w_tef;
        r3_a_event_time  <= r_w_time;
      end if;
      
      r3_a_delayed     <= s_mr_delayed;
      r3_a_conflict    <= s_mr_conflict;
      r3_a_late        <= s_mr_late;
      r3_a_early       <= s_mr_early;
      r3_a_num         <= s_mr_num;
      r3_a_tag         <= s_mr_tag;
      r3_a_channel     <= s_mr_channel;
      r3_a_valid       <= r_w_valid;
      
      r3_a_offset_time <= s_mr_time;
      
      r2_a_delayed     <= r3_a_delayed;
      r2_a_conflict    <= r3_a_conflict;
      r2_a_late        <= r3_a_late;
      r2_a_early       <= r3_a_early;
      r2_a_num         <= r3_a_num;
      r2_a_event       <= r3_a_event;
      r2_a_param       <= r3_a_param;
      r2_a_tag         <= r3_a_tag;
      r2_a_tef         <= r3_a_tef;
      r2_a_channel     <= r3_a_channel;
      r2_a_valid       <= r3_a_valid;
      
      r1_a_delayed     <= r2_a_delayed;
      r1_a_conflict    <= r2_a_conflict;
      r1_a_late        <= r2_a_late;
      r1_a_early       <= r2_a_early;
      r1_a_num         <= r2_a_num;
      r1_a_event       <= r2_a_event;
      r1_a_param       <= r2_a_param;
      r1_a_tag         <= r2_a_tag;
      r1_a_tef         <= r2_a_tef;
      
      for i in 0 to g_num_channels-1 loop
        r1_a_validv(i) <= 
          r2_a_valid and
          f_eca_eq(r2_a_channel, std_logic_vector(to_unsigned(i, r2_a_channel'length)));
      end loop;
    end if;
  end process;
  
  adder : eca_adder
    port map(
      clk_i   => clk_i,
      stall_i => '0',
      a_i     => r3_a_event_time,
      b_i     => r3_a_offset_time,
      c_i     => '0',
      c1_o    => open,
      x2_o    => s1_a_action_time,
      c2_o    => open);
  
  channels : for i in 0 to g_num_channels-1 generate
    q_channel_o(i).valid    <= r1_a_validv(i);
    q_channel_o(i).delayed  <= r1_a_delayed;
    q_channel_o(i).conflict <= r1_a_conflict;
    q_channel_o(i).late     <= r1_a_late;
    q_channel_o(i).early    <= r1_a_early;
    q_channel_o(i).num      <= r1_a_num;
    q_channel_o(i).event    <= r1_a_event;
    q_channel_o(i).param    <= r1_a_param;
    q_channel_o(i).tag      <= r1_a_tag;
    q_channel_o(i).tef      <= r1_a_tef;
    q_channel_o(i).deadline <= s1_a_action_time;
    q_channel_o(i).executed <= (others => '0');
  end generate;
  
end rtl;
