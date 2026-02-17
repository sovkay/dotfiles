set -x ANDROID_HOME "$HOME/Library/Android/sdk"
set -x ANDROID_SDK_ROOT "$HOME/Library/Android/sdk"

set -x PATH $ANDROID_HOME/emulator $PATH
set -x PATH $ANDROID_HOME/tools $PATH
set -x PATH $ANDROID_HOME/platform-tools $PATH