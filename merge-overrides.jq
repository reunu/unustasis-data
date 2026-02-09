# Load upstream garages and overrides
. as $upstream |
$overrides[0] as $ovr |

# Helper function to check if a garage matches the criteria
def matches($override; $garage):
  $override.match | to_entries | all(.key as $k | .value as $v | $garage[$k] == $v);

# Build a function to check if a garage should be removed
def shouldRemove($garage):
  $ovr | any(select(.operation == "remove") | matches(.; $garage));

# Filter out removed garages, handle updates, and append new garages
$upstream |
map(select(shouldRemove(.) | not)) |
map(
  . as $garage |
  ($ovr[] | select(.operation == "update") | select(matches(.; $garage)) | .garage) // $garage
) |
. + ($ovr | map(select(.operation == "add") | .garage))
