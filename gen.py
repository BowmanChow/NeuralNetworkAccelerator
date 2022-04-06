import random

# with open("x.txt", 'w') as f_in:
#     with open("y.txt", 'w') as f_out:
#         for i in range(-2**7, 2**7, 2):
#             for j in range(-2**7, 2**7, 2):
#                 f_in.write(bin(i & 0xFF)[2:].zfill(8))
#                 # f_in.write(' ')
#                 f_in.write(bin(j & 0xFF)[2:].zfill(8))
#                 f_in.write('\n')
#                 f_out.write(bin((i * j) & 0xFFFF)[2:].zfill(16))
#                 f_out.write('\n')
        

with open("x.txt", 'w') as f_in:
    with open("y.txt", 'w') as f_out:
        for count in range(0x8000):
            i = random.randint(-2**7, 2**7-1)
            j = random.randint(-2**7, 2**7-1)
            f_in.write(bin(i & 0xFF)[2:].zfill(8))
            # f_in.write(' ')
            f_in.write(bin(j & 0xFF)[2:].zfill(8))
            f_in.write('\n')
            f_out.write(bin((i * j) & 0xFFFF)[2:].zfill(16))
            f_out.write('\n')