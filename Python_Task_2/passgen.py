import argparse
import string
import random
import file_patterns
import logging
import sys

TOKENS = {'A': string.ascii_uppercase,
          'a': string.ascii_lowercase,
          'p': string.punctuation,
          'd': string.digits,
          '-': '-',
          '@': '@'
          }

CRITICAL_ERROR = 1


def pars_input_keys() -> tuple:
    """
    :return: tuple which consist of fourth elements in next order: input password length,
                  input template, number of templates from file, numbers of passwords
    """
    keys_parser = argparse.ArgumentParser(description='Generate password from random sequences')
    # Add the arguments
    keys_parser.add_argument('-l', '--length', action='store', type=int,
                             help='set up password length')
    keys_parser.add_argument('-t', '--template', action='store', type=str,
                             help='set up pattern')
    keys_parser.add_argument('-f', action='store', type=int,
                             help='getting list of patterns from file')
    keys_parser.add_argument('-c', '--count', action='store', type=int,
                             help='set number ща passwords')
    keys_parser.add_argument('-v', '--verbose', action='count',
                             help='output description program executing', default=0)
    # Execute the parse_args() method
    args = keys_parser.parse_args()
    # logging settings, output to console only if inputted flag verbose
    if args.verbose != 0:
        levels = [logging.WARNING, logging.INFO, logging.DEBUG, logging.ERROR]
        logging.basicConfig(format="%(asctime)s [%(levelname)s] %(message)s",
                            level=levels[args.verbose],
                            handlers=[
                                logging.FileHandler("debug.log"),
                                logging.StreamHandler()
                            ])
    else:
        logging.basicConfig(format="%(asctime)s [%(levelname)s] %(message)s",
                            level=logging.DEBUG,
                            handlers=[
                                logging.FileHandler("debug.log"),
                            ])

    logging.debug(f'There were assigned variables input_length: {args.length},'
                  f' input_template: {args.template}, template_list: {args.f},'
                  f' template_numbers: {args.count}')

    return args.length, args.template, args.f, args.count


def password_gen_from_length(length=8, chars=string.ascii_letters + string.digits) -> str:
    """
    Set length of password and generate random password from set
    small lateral ASCII, big lateral ASCII and digits
    :param length: It's the first element of the output pars_input_keys() function
    :param chars: It's sequence of characters for building password
    :return: string
    """
    return ''.join(random.choice(chars) for _ in range(length))


def pars_pattern(pattern: str) -> list[dict]:
    """
    This function parses inputted string(pattern)
    :param pattern: It's the second element of the output pars_input_keys() function.
    For example "A4%[d%a%]3%-%a2%"
    :return: list of dictionary where the first key is count of tokens and the second key
    is sequence of characters according to the TOKENS dictionary
    """
    token = {
        "len": 0,
        "sequence": ""
    }
    if len(pattern) == 0:
        return [token, ]

    else:
        if pattern[0] == "[":
            i = pattern.index("]")
            token["sequence"] = pars_pattern(pattern[1:i])
            pattern = pattern[i + 1:]
        else:
            token["sequence"] = TOKENS[pattern[0]]
            pattern = pattern[1:]

        index = pattern.index("%")
        token["len"] = 1 if pattern[0] == "%" else int(pattern[:index])
        sequence = pars_pattern(pattern[index + 1:])
        result = [token, ] + sequence
    return result


def passgen_from_template(result: list[dict]) -> str:
    passwd = ""
    sequence_str = ""
    i = 0
    while i < len(result):
        if isinstance(result[i]["sequence"], str):
            passwd += "".join(random.choice(result[i]["sequence"]) for _ in range(result[i]["len"]))

        elif isinstance(result[i]["sequence"], list):
            count = result[i]["len"]
            for x in result[i]["sequence"]:
                sequence_str += x["sequence"]
            passwd += "".join(random.choice(sequence_str) for _ in range(count))
        i += 1

    return passwd


def get_patterns_from_file(number_of_lists: int, file) -> str:
    password = ""
    random_patterns_list = []
    i = 0
    while i < number_of_lists:
        random_patterns_list += [random.choice(file.list_patterns)]
        i += 1
    for x in random_patterns_list:
        password += passgen_from_template(pars_pattern(x)) + "\n"
    return password


def password_gen(func: tuple) -> str:
    """
    Call function depend on keys which were inputted from CLI
    :param func: argparse function, which return a tuple of values
    :return: string (password)
    """
    tuple_var = func  # set variables in next order (args.length, args.template, args.f, args.count)
    result = ""  # This is for stored generated password. Value this variable depend on condition
    # Check if for args.length or args.count statements were inputted zero
    for variables in tuple_var:
        if variables == 0:
            logging.error('Zero statement forbidden here!')
            sys.exit(CRITICAL_ERROR)
    # Condition which is call function depend on keys which were inputted from CLI
    logging.info(f'Generating password according to entered flags')
    if tuple_var[3] is not None:
        if tuple_var[0] is not None:
            password = ""
            i = 0
            while i < tuple_var[3]:
                password += password_gen_from_length(length=tuple_var[0]) + "\n"
                i += 1
            logging.debug(f'Generating password by random choices'
                          f' from small lateral ASCII, big lateral ASCII, digit'
                          f' {tuple_var[3]} times with length {tuple_var[0]}')
            result = password

        elif tuple_var[1] is not None:
            # Check if pattern doesn't end with "%"
            if not tuple_var[1].endswith("%"):
                logging.error('Pattern must be ending with "%"')
                sys.exit(CRITICAL_ERROR)
            password = ""
            i = 0
            logging.debug(f'Generating password according to template: {tuple_var[1]}'
                          f' {tuple_var[3]} times')
            while i < tuple_var[3]:
                password += passgen_from_template(pars_pattern(tuple_var[1])) + "\n"
                i += 1
            result = password
    else:
        if tuple_var[0] is not None:
            logging.debug(f'Generating password by random choices'
                          f' from small lateral ASCII, big lateral ASCII, digit'
                          f' with length {tuple_var[0]}')
            result = password_gen_from_length(length=tuple_var[0])
        elif tuple_var[1] is not None:
            if not tuple_var[1].endswith("%"):
                logging.error('Pattern must be ending with "%"')
                sys.exit(CRITICAL_ERROR)
            logging.debug(f'Generating password according to template: {tuple_var[1]}')
            result = passgen_from_template(pars_pattern(tuple_var[1]))
        elif tuple_var[2] is not None:
            logging.debug(f'Generating password for each template in template list'
                          f'which was created by random selection from file'
                          )
            result = get_patterns_from_file(tuple_var[2], file_patterns)

    return result


if __name__ == "__main__":
    print(password_gen(pars_input_keys()))
