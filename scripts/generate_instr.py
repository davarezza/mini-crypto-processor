import sys

def to_bin(value, bits):
    return format(value, f'0{bits}b')

def make_load(rd, imm):
    opcode = '0001'
    rd_bin = to_bin(rd, 4)
    rs_bin = to_bin(imm, 8)
    return opcode + rd_bin + rs_bin

def make_xorenc():
    opcode = '1000'
    rd = '0001'
    rs1 = '0010'
    rs2 = '0011'
    return opcode + rd + rs1 + rs2

def make_store(addr):
    opcode = '0100'
    rd = '0000'
    addr_bin = to_bin(addr, 8)
    return opcode + rd + addr_bin

def make_halt():
    return '1111000000000000'

def generate(text, key):
    instr = []
    addr = 0

    for ch in text:
        ascii_val = ord(ch)

        instr.append(make_load(2, ascii_val))  
        instr.append(make_load(3, key))         
        instr.append(make_xorenc())             
        instr.append(make_store(addr))          

        addr += 1

    instr.append(make_halt())
    return instr

if __name__ == '__main__':
    with open('input.txt', 'r', encoding='utf8') as f:
        text = f.read()

    key = 0x20  

    instructions = generate(text, key)

    print('module instr_mem(')
    print('    input [7:0] address,')
    print('    output reg [15:0] instruction')
    print(');')
    print('')
    print('always @(*) begin')
    print('    case(address)')

    for i, inst in enumerate(instructions):
        print(f"        8'd{i}: instruction = 16'b{inst};")

    print("        default: instruction = 16'b1111000000000000;")
    print('    endcase')
    print('end')
    print('endmodule')