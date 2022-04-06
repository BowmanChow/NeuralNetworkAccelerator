import itertools

partial_pro1 = [
    5*[''] + ['~`P[0][8]', '`P[0][8]'] + ['`P[0]['+str(i)+']' for i in range(8, -1, -1)],
    4*[''] + ['1\'b1', '~`P[1][8]'] + ['`P[1]['+str(i)+']' for i in range(7, -1, -1)] + ['', '`N[0]'],
    2*[''] + ['1\'b1', '~`P[2][8]'] + ['`P[2]['+str(i)+']' for i in range(7, -1, -1)] + ['', '`N[1]'],
    ['1\'b1', '~`P[3][8]'] + ['`P[3]['+str(i)+']' for i in range(7, -1, -1)] + ['', '`N[2]'],
    9*[''] + ['`N[3]']
]

partial_pro2 = [
    5*[''] + ['~`P[0][8]', '`P[0][8]'] + ['`P[0]['+str(i)+']' for i in range(8, -1, -1)],
    4*[''] + ['1\'b1', '~`P[1][8]'] + ['`P[1]['+str(i)+']' for i in range(7, -1, -1)] + ['1\'b1', '`N[0]'],
    2*[''] + ['1\'b1', '~`P[2][8]'] + ['`P[2]['+str(i)+']' for i in range(7, -1, -1)] + [''],
    ['1\'b1', '~`P[3][8]'] + ['`P[3]['+str(i)+']' for i in range(7, -1, -1)] + ['', '`N[2]'],
    9*[''] + ['`N[3]']
]

partial_pro3 = [
    5*[''] + ['~`P[0][8]', '`P[0][8]'] + ['`P[0]['+str(i)+']' for i in range(8, -1, -1)],
    4*[''] + ['1\'b1', '~`P[1][8]'] + ['`P[1]['+str(i)+']' for i in range(7, -1, -1)] + ['1\'b1'],
    2*[''] + ['1\'b1', '~`P[2][8]'] + ['`P[2]['+str(i)+']' for i in range(7, -1, -1)] + [''],
    ['1\'b1', '~`P[3][8]'] + ['`P[3]['+str(i)+']' for i in range(7, -1, -1)] + ['', '`N[2]'],
    9*[''] + ['`N[3]']
]

partial_pro4 = [
    5*[''] + ['~`P[0][8]', '`P[0][8]'] + ['`P[0]['+str(i)+']' for i in range(8, -1, -1)],
    4*[''] + ['1\'b1', '~`P[1][8]'] + ['`P[1]['+str(i)+']' for i in range(7, -1, -1)] + ['1\'b1'],
    2*[''] + ['1\'b1', '~`P[2][8]'] + ['`P[2]['+str(i)+']' for i in range(7, -1, -1)] + [''],
    ['1\'b1', '~`P[3][8]'] + ['`P[3]['+str(i)+']' for i in range(7, -1, -1)] + ['1\'b1', '`N[2]']
]


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def print_list(list, color=None, end='\n'):
    if color:
        print(color, end='')
    for n in list:
        print('{:10s}'.format(n), end='')
    if color:
        print(bcolors.ENDC, end='')
    print(end=end)

def print_list_list(list):
    for p in list:
        for n in p:
            print('{:10s}'.format(n), end='')
        print()
    print()

partial_pro = partial_pro1
print_list_list(partial_pro)

def transpose_list(l, fill=None):
    return list(map(list, itertools.zip_longest(*l, fillvalue=fill)))

def strip_list(l, item):
    while item in l:
        l.remove(item)
    return l

def trans_partial_pro(partial_pro):
    trans = transpose_list(partial_pro, '')
    stripped = [strip_list(l, '') for l in trans]
    return stripped[::-1]

pp = trans_partial_pro(partial_pro)
print_list_list(pp)

all_codes = []


def gen_code(s, c, adder, addees):
    code = []
    code.append('wire {0}, {1};'.format(s, c))
    if len(addees) == 3:
        module = 'FULL_ADDER'
    elif len(addees) == 2:
        module = 'HALF_ADDER'
    elif len(addees) == 4:
        module = 'APPROX_ADDER_4'

    if '1\'b1' in addees:
        module += '_1_BIT_1'
        addees = strip_list(addees, '1\'b1')
    if len(addees) == 4:
        args = '.a({0}), .b({1}), .c({2}), .d({3})'.format(addees[0], addees[1], addees[2], addees[3])
    elif len(addees) == 3:
        args = '.a({0}), .b({1}), .ci({2})'.format(addees[0], addees[1], addees[2])
    elif len(addees) == 2:
        args = '.a({0}), .b({1})'.format(addees[0], addees[1])
    else:
        args = '.a({0})'.format(addees[0])
    code.append('{mod} {adder}( .co({c}), .sum({s}), {args} );'.format(mod=module, adder=adder, c=c, s=s, args=args))
    return code

def merge_partial_product(pp, addee_nums, token):
    print(10*'-'+' merge '+10*'-')
    code = []
    new_pp = [[] for i in range(len(pp))]
    for bit in range(len(pp)):
        if addee_nums[bit] > len(pp[bit]):
            raise Exception('Exception : addee_nums too big')
        addees = pp[bit][:addee_nums[bit]]
        print_list(addees, bcolors.FAIL, end='')
        remains = pp[bit][addee_nums[bit]:]
        print_list(remains, end='')
        new_pp[bit] = remains + new_pp[bit]
        if addees:
            marker = '{0}_{1}'.format(bit, token)
            s, c, adder = 'm_S'+marker, 'm_C'+marker, 'm_adder'+marker
            new_pp[bit].append(s)
            new_pp[bit+1].append(c)
            code += gen_code(s, c, adder, addees)
        print()
    print(10*'-'+' merge '+10*'-')
    return code, new_pp

# token = 1
# for count in range(2):
#     addee_nums = []
#     for p in pp:
#         if len(p) >= 4:
#             addee_nums.append(4)
#         else:
#             addee_nums.append(0)
#     if not (4 in addee_nums):
#         break
#     code, pp = merge_partial_product(pp, addee_nums, str(token))
#     token += 1
#     print_list_list(pp)
#     # print('\n'.join(code))
#     all_codes.append(code)

# code, pp = merge_partial_product(pp, 2*[0] + [3, 0] + 8*[3] + 4*[0], '0')
# print_list_list(pp)
# print('\n'.join(code))
# for c in all_codes:
#     print('\n'.join(c))

# code, pp = merge_partial_product(pp, 5*[0] + 7*[4] + 4*[0], '0')
# print_list_list(pp)
# print('\n'.join(code))

def reduce_last_col(pp):
    print(10*'-'+' reduce begin '+10*'-')
    code = []
    for bit in range(len(pp)-1):
        index = 0
        while (len(pp[bit]) >= 2):
            print('{i}\'s reduction'.format(i=index))
            print_list(pp[bit], end='')
            addees = pp[bit][:3]
            marker = '{0}_{1}'.format(bit, index)
            s, c, adder = 'm_S'+marker, 'm_C'+marker, 'm_adder'+marker
            code += gen_code(s, c, adder, addees)

            print('{:10s}'.format('-->'), end='')
            pp[bit] = pp[bit][3:] + [s]
            pp[bit+1].append(c)
            print_list(pp[bit])
            print_list(pp[bit+1])

            index += 1
        if index:
            return pp, code

while True:
    result = reduce_last_col(pp)
    if not result:
        break
    pp, code = result
    all_codes += code
    print('\n')
    print('\n'.join(code))
    # print_list_list(pp)

print('\n'.join(all_codes))
trans_list = transpose_list(pp, fill='1\'b0')
print('{{{list}}}'.format(list=', '.join(trans_list[0][::-1])))