module.exports =
  OK                    : 0 # processing successfully
  COMMAND_LINE_ARG_ERROR: 2 # error processing command-line arguments.
                            # This value must be 2 because argparse set this value and we dont want to intercept!