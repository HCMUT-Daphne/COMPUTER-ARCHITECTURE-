import sys

def text_to_hex(text):
    hex_string = ""
    for char in text:
        hex_value = hex(ord(char)).lstrip("0x").upper()
        hex_string += hex_value + " "
    return hex_string.strip()

def hex_to_asm(hex_string):
    asm_code = ""
    hex_values = hex_string.split()
    for hex_val in hex_values:
        asm_code += f"ori x28, x27, 0x{hex_val}\n"
        asm_code += "jal x25, lcd\n"
    return asm_code

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python str2ascii.py <text>")
        sys.exit(1)
    
    text_input = sys.argv[1]
    hex_output = text_to_hex(text_input)
    print("Hex ASCII:", hex_output)

    asm_output = hex_to_asm(hex_output)
    print("\nAssembly Code:")
    print(asm_output)
