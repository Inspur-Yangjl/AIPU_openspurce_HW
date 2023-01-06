// ================================================================
// NVDLA Open Source Project
//
// Copyright(c) 2016 - 2017 NVIDIA Corporation. Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with
// this distribution for more information.
// ================================================================
// File Name: NV_NVDLA_SDP_HLS_X_int_relu.v
//
`define SYNTHESIS
//
module NV_NVDLA_SDP_HLS_X_int_relu (
   cfg_relu_bypass //|< i
  ,nvdla_core_clk //|< i
  ,nvdla_core_rstn //|< i
  ,relu_out_prdy //|< i
  ,trt_data_out //|< i
  ,trt_out_pvld //|< i
  ,relu_data_out //|> o
  ,relu_out_pvld //|> o
  ,trt_out_prdy //|> o
  );
//parameter X_OUT_WIDTH = 32;
input nvdla_core_clk;
input nvdla_core_rstn;
input cfg_relu_bypass;
input trt_out_pvld;
output trt_out_prdy;
input [31:0] trt_data_out;
output [31:0] relu_data_out;
output relu_out_pvld;
input relu_out_prdy;
wire [31:0] relu_dout;
wire [31:0] relu_out;
// synoff nets
// monitor nets
// debug nets
// tie high nets
// tie low nets
// no connect nets
// not all bits used nets
// todo nets
NV_NVDLA_SDP_HLS_relu #(.DATA_WIDTH(32 )) u_x_relu (
   .data_in (trt_data_out[31:0]) //|< i
  ,.data_out (relu_out[31:0]) //|> w
  );
assign relu_dout[31:0] = cfg_relu_bypass ? trt_data_out[31:0] : relu_out[31:0];
NV_NVDLA_SDP_HLS_X_INT_RELU_pipe_p1 pipe_p1 (
   .nvdla_core_clk (nvdla_core_clk) //|< i
  ,.nvdla_core_rstn (nvdla_core_rstn) //|< i
  ,.relu_dout (relu_dout[31:0]) //|< w
  ,.relu_out_prdy (relu_out_prdy) //|< i
  ,.trt_out_pvld (trt_out_pvld) //|< i
  ,.relu_data_out (relu_data_out[31:0]) //|> o
  ,.relu_out_pvld (relu_out_pvld) //|> o
  ,.trt_out_prdy (trt_out_prdy) //|> o
  );
endmodule // NV_NVDLA_SDP_HLS_X_int_relu
// **************************************************************************************************************
// Generated by ::pipe -m -bc -rand none -is relu_data_out[31:0] (relu_out_pvld,relu_out_prdy) <= relu_dout[31:0] (trt_out_pvld,trt_out_prdy)
// **************************************************************************************************************
module NV_NVDLA_SDP_HLS_X_INT_RELU_pipe_p1 (
   nvdla_core_clk
  ,nvdla_core_rstn
  ,relu_dout
  ,relu_out_prdy
  ,trt_out_pvld
  ,relu_data_out
  ,relu_out_pvld
  ,trt_out_prdy
  );
input nvdla_core_clk;
input nvdla_core_rstn;
input [31:0] relu_dout;
input relu_out_prdy;
input trt_out_pvld;
output [31:0] relu_data_out;
output relu_out_pvld;
output trt_out_prdy;
reg [31:0] p1_pipe_data;
reg p1_pipe_ready;
reg p1_pipe_ready_bc;
reg p1_pipe_valid;
reg p1_skid_catch;
reg [31:0] p1_skid_data;
reg [31:0] p1_skid_pipe_data;
reg p1_skid_pipe_ready;
reg p1_skid_pipe_valid;
reg p1_skid_ready;
reg p1_skid_ready_flop;
reg p1_skid_valid;
reg [31:0] relu_data_out;
reg relu_out_pvld;
reg trt_out_prdy;
//## pipe (1) skid buffer
always @(
  trt_out_pvld
  or p1_skid_ready_flop
  or p1_skid_pipe_ready
  or p1_skid_valid
  ) begin
  p1_skid_catch = trt_out_pvld && p1_skid_ready_flop && !p1_skid_pipe_ready;
  p1_skid_ready = (p1_skid_valid)? p1_skid_pipe_ready : !p1_skid_catch;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_skid_valid <= 1'b0;
    p1_skid_ready_flop <= 1'b1;
    trt_out_prdy <= 1'b1;
  end else begin
  p1_skid_valid <= (p1_skid_valid)? !p1_skid_pipe_ready : p1_skid_catch;
  p1_skid_ready_flop <= p1_skid_ready;
  trt_out_prdy <= p1_skid_ready;
  end
end
always @(posedge nvdla_core_clk) begin
// VCS sop_coverage_off start
  p1_skid_data <= (p1_skid_catch)? relu_dout[31:0] : p1_skid_data;
// VCS sop_coverage_off end
end
always @(
  p1_skid_ready_flop
  or trt_out_pvld
  or p1_skid_valid
  or relu_dout
  or p1_skid_data
  ) begin
  p1_skid_pipe_valid = (p1_skid_ready_flop)? trt_out_pvld : p1_skid_valid;
// VCS sop_coverage_off start
  p1_skid_pipe_data = (p1_skid_ready_flop)? relu_dout[31:0] : p1_skid_data;
// VCS sop_coverage_off end
end
//## pipe (1) valid-ready-bubble-collapse
always @(
  p1_pipe_ready
  or p1_pipe_valid
  ) begin
  p1_pipe_ready_bc = p1_pipe_ready || !p1_pipe_valid;
end
always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
  if (!nvdla_core_rstn) begin
    p1_pipe_valid <= 1'b0;
  end else begin
  p1_pipe_valid <= (p1_pipe_ready_bc)? p1_skid_pipe_valid : 1'd1;
  end
end
always @(posedge nvdla_core_clk) begin
// VCS sop_coverage_off start
  p1_pipe_data <= (p1_pipe_ready_bc && p1_skid_pipe_valid)? p1_skid_pipe_data : p1_pipe_data;
// VCS sop_coverage_off end
end
always @(
  p1_pipe_ready_bc
  ) begin
  p1_skid_pipe_ready = p1_pipe_ready_bc;
end
//## pipe (1) output
always @(
  p1_pipe_valid
  or relu_out_prdy
  or p1_pipe_data
  ) begin
  relu_out_pvld = p1_pipe_valid;
  p1_pipe_ready = relu_out_prdy;
  relu_data_out[31:0] = p1_pipe_data;
end
//## pipe (1) assertions/testpoints
`ifndef VIVA_PLUGIN_PIPE_DISABLE_ASSERTIONS
wire p1_assert_clk = nvdla_core_clk;
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML
// spyglass disable_block STARC-2.10.3.2a
// spyglass disable_block STARC05-2.1.3.1
// spyglass disable_block STARC-2.1.4.6
// spyglass disable_block W116
// spyglass disable_block W154
// spyglass disable_block W239
// spyglass disable_block W362
// spyglass disable_block WRN_58
// spyglass disable_block WRN_61
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
`ifndef SYNTHESIS
// VCS coverage off
  nv_assert_no_x #(0,1,0,"No X's allowed on control signals") zzz_assert_no_x_1x (nvdla_core_clk, `ASSERT_RESET, nvdla_core_rstn, (relu_out_pvld^relu_out_prdy^trt_out_pvld^trt_out_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
// VCS coverage on
`endif
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML
// spyglass enable_block STARC-2.10.3.2a
// spyglass enable_block STARC05-2.1.3.1
// spyglass enable_block STARC-2.1.4.6
// spyglass enable_block W116
// spyglass enable_block W154
// spyglass enable_block W239
// spyglass enable_block W362
// spyglass enable_block WRN_58
// spyglass enable_block WRN_61
`endif // SPYGLASS_ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass disable_block NoWidthInBasedNum-ML
// spyglass disable_block STARC-2.10.3.2a
// spyglass disable_block STARC05-2.1.3.1
// spyglass disable_block STARC-2.1.4.6
// spyglass disable_block W116
// spyglass disable_block W154
// spyglass disable_block W239
// spyglass disable_block W362
// spyglass disable_block WRN_58
// spyglass disable_block WRN_61
`endif // SPYGLASS_ASSERT_ON
`ifdef ASSERT_ON
`ifdef FV_ASSERT_ON
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef SYNTHESIS
`define ASSERT_RESET nvdla_core_rstn
`else
`ifdef ASSERT_OFF_RESET_IS_X
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b0 : nvdla_core_rstn)
`else
`define ASSERT_RESET ((1'bx === nvdla_core_rstn) ? 1'b1 : nvdla_core_rstn)
`endif // ASSERT_OFF_RESET_IS_X
`endif // SYNTHESIS
`endif // FV_ASSERT_ON
// VCS coverage off
  nv_assert_hold_throughout_event_interval #(0,1,0,"valid removed before ready") zzz_assert_hold_throughout_event_interval_2x (nvdla_core_clk, `ASSERT_RESET, (trt_out_pvld && !trt_out_prdy), (trt_out_pvld), (trt_out_prdy)); // spyglass disable W504 SelfDeterminedExpr-ML 
// VCS coverage on
`undef ASSERT_RESET
`endif // ASSERT_ON
`ifdef SPYGLASS_ASSERT_ON
`else
// spyglass enable_block NoWidthInBasedNum-ML
// spyglass enable_block STARC-2.10.3.2a
// spyglass enable_block STARC05-2.1.3.1
// spyglass enable_block STARC-2.1.4.6
// spyglass enable_block W116
// spyglass enable_block W154
// spyglass enable_block W239
// spyglass enable_block W362
// spyglass enable_block WRN_58
// spyglass enable_block WRN_61
`endif // SPYGLASS_ASSERT_ON
`endif
endmodule // NV_NVDLA_SDP_HLS_X_INT_RELU_pipe_p1
