#!/bin/bash

# Setup environment
# -----------------

# Get the value of the FAIL_ON_WARNINGS environment variable and if it exists, parse the boolean value and add the option to the command.
if [ -z "$FAIL_ON_WARNINGS" ]; then
  # Do nothing if the variable is not set or is empty.
  echo "FAIL_ON_WARNINGS is not set, defaulting to false."
else
  if [ "$FAIL_ON_WARNINGS" = true ] || [ "$FAIL_ON_WARNINGS" = True ] || [ "$FAIL_ON_WARNINGS" = TRUE ]; then
    options+=(-f parsable)
  fi
fi

# Get the value of the IGNORE_WARNINGS environment variable and if it exists, parse the boolean value and add the option to the command.
if [ -z "$IGNORE_WARNINGS" ]; then
  # Do nothing if the variable is not set or is empty.
  echo "IGNORE_WARNINGS is not set, defaulting to false."
else
  if [ "$IGNORE_WARNINGS" = true ] || [ "$IGNORE_WARNINGS" = True ] || [ "$IGNORE_WARNINGS" = TRUE ]; then
    options+=(-w)
  fi
fi

# If the config file environment variable is set, use it. Otherwise, use the default config file found in the root of the repository.
if [ -z "$CONFIG_FILE" ]; then
  # Do nothing if the variable is not set or is empty.
  echo "CONFIG_FILE is not set, defaulting to actions .yamllint"
else
  options+=(-c "$CONFIG_FILE")
fi

# Install yamllint if not installed already
if ! command -v yamllint &>/dev/null; then
  echo "yamllint could not be found, installing..."
  sudo apt-get install -y yamllint
fi

# Run yamllint
# ------------

# Run yamllint with the options set above and the path given as an argument when calling the script.
yamllint "${options[@]}" ./ || exit 1
