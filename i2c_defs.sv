// System Verilog generated by alr2 v0.11
// Generated on 2019-11-13 17:32:39.466902946 UTC
//
`timescale 1ns/10ps




typedef struct packed {
    logic [6:0] ADR;
    logic reserved;
} IADR;
typedef struct packed {
    logic [5:0] IC;
} DIVR;
typedef struct packed {
    logic IEN;
    logic IIEN;
    logic MSTA;
    logic MTX;
    logic TXAK;
    logic RSTA;
    logic [1:0] reserved_1_0;
} CR;
typedef struct packed {
    logic ICF;
    logic IAAS;
    logic IBB;
    logic IAL;
    logic reserved;
    logic SRW;
    logic IIF;
    logic RXAK;
} SR;
typedef struct packed {
    logic [7:0] DATA;
} DR;
