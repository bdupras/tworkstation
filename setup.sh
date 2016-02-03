#!/bin/bash -e
# see also: https://github.com/mathiasbynens/dotfiles/blob/master/.osx

SETUP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update `sudo` time stamp in the background until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo systemsetup -setcomputersleep Never
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
sudo systemsetup -settimezone "America/Denver" > /dev/null

defaults write NSGlobalDomain KeyRepeat -int 2

## Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock workspaces-swoosh-animation-off -bool true
defaults write com.apple.dock tilesize -int 20

## Finder
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder AppleShowAllFiles -bool false
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Use list view by default. Other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

defaults write com.googlecode.iterm2 PromptOnQuit -bool false

defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

defaults write com.irradiatedsoftware.SizeUp StartAtLogin -bool true
defaults write com.irradiatedsoftware.SizeUp ShowPrefsOnNextStart -bool false


# Install Sublime Text settings
# cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null

defaults write com.twitter.twitter-mac AutomaticQuoteSubstitutionEnabled -bool false
defaults write com.twitter.twitter-mac MenuItemBehavior -int 1
defaults write com.twitter.twitter-mac ShowDevelopMenu -bool true
defaults write com.twitter.twitter-mac openLinksInBackground -bool true
defaults write com.twitter.twitter-mac ESCClosesComposeWindow -bool true
defaults write com.twitter.twitter-mac ShowFullNames -bool true
defaults write com.twitter.twitter-mac HideInBackground -bool true

mkdir -p ${HOME}/projects 
mkdir -p ${HOME}/workspace
mkdir -p ${HOME}/Library/Scripts

cp -a ${SETUP_DIR}/files/home/ ${HOME}

which -s brew || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

brew update && brew upgrade && brew cleanup && brew cask cleanup
brew install libxml2
brew install phantomjs198
brew install watch
brew install awscli
brew install ag
brew install gpg
brew install homebrew/science/openfst
brew install caskroom/cask/brew-cask
brew install Caskroom/cask/java
brew tap caskroom/versions

brew cask install google-chrome
brew cask install caffeine
brew cask install sizeup
brew cask install fastscripts
brew cask install dropbox
brew cask install sequel-pro
brew cask install sublime-text3
brew cask install iterm2
brew cask install flux
brew cask install kindle
brew cask install screenhero
brew cask install utc-menu-clock
brew cask install cyberduck
brew cask install wireshark
brew cask install adium

###############################################################################
# Restart affected applications                                               #
###############################################################################

for app in "Dock" "Finder"; do
  killall -HUP "${app}" &>/dev/null
done

echo "Done. Note that some of these changes may require a logout/restart to take effect."
