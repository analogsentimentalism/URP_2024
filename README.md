# URP_2024
Verilog implementation of CPU

## modules

- ALU
- ???

## testbenches

- module testbenches
- top-module testbench

## modelsim

컴퓨터에 깔려있는게 modelsim이라 일단은 modelsim으로 만들었음. 나중에 Vivado든 vcs든 바꾸면 될듯.

=> 연구실 툴 라이센스 사용할 수 있나 물어보기? e.g. vcs, Verdi, simvision, xcelium 등등...

## ETC

> [!NOTE] systemVerilog
> 너무 자빠지지만 않으면 해보는 것도 좋을 것 같은데 추가 과제 정도로 생각해도 될듯

> [!NOTE] FPGA
> 진짜 이건 해보면 좋은데... 아님 말고

기본적으로 설계 / 검증 파트로 나누어서 진행하면 될듯. 설계 단계에선 CPU 이해, 모듈 별 설계, top module 만들기, 간단한 RTL 시뮬레이션 / FPGA 시뮬레이션 정도로 하면 될듯. 검증 파트는 각 레지스터 / 기능이 잘 동작하는지 체크리스트 만들어서 검증해보면 될듯.

=> 욕심으로는 검증 파트에서 Coverage까지 해보고 싶은데 솔직히 개어려움.

