;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. "~/.mycontribs/")
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     ;; auto-completion
     ;; better-defaults
     emacs-lisp
     ;; git
     helm
     ;; lsp
     ;; markdown
     multiple-cursors
     (org :variables
          org-enable-github-support t
          org-enable-notifications t
          org-start-notification-daemon-on-startup t)
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     ;; spell-checking
     ;; syntax-checking
     ;; version-control
     treemacs)


   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '()

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; Scale factor controls the scaling (size) of the startup banner. Default
   ;; value is `auto' for scaling the logo automatically to fit all buffer
   ;; contents, to a maximum of the full image height and a minimum of 3 line
   ;; heights. If set to a number (int or float) it is used as a constant
   ;; scaling factor for the default logo size.
   dotspacemacs-startup-banner-scale 'auto

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; If non-nil, show file icons for entries and headings on Spacemacs home buffer.
   ;; This has no effect in terminal or if "nerd-icons" package or the font
   ;; is not installed. (default nil)
   dotspacemacs-startup-buffer-show-icons nil

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light). A theme from external
   ;; package can be defined with `:package', or a theme can be defined with
   ;; `:location' to download the theme package, refer the themes section in
   ;; DOCUMENTATION.org for the full theme specifications.
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts. This setting has no effect when
   ;; running Emacs in terminal. The font set here will be used for default and
   ;; fixed-pitch faces. The `:size' can be specified as
   ;; a non-negative integer (pixel size), or a floating-point (point size).
   ;; Point size is recommended, because it's device independent. (default 10.0)
   dotspacemacs-default-font '("Source Code Pro"
                               :size 10.0
                               :weight normal
                               :width normal)

   ;; Default icons font, it can be `all-the-icons' or `nerd-icons'.
   dotspacemacs-default-icons-font 'all-the-icons

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "M-<return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "M-<return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; It is also possible to use a posframe with the following cons cell
   ;; `(posframe . position)' where position can be one of `center',
   ;; `top-center', `bottom-center', `top-left-corner', `top-right-corner',
   ;; `top-right-corner', `bottom-left-corner' or `bottom-right-corner'
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; Make consecutive tab key presses after commands such as
   ;; `spacemacs/alternate-buffer' (SPC TAB) cycle through previous
   ;; buffers/windows/etc. Please see the option's docstring for more information.
   ;; Set the option to t in order to enable cycling for all current and
   ;; future cycling commands. Alternatively, choose a subset of the currently
   ;; supported commands: '(alternate-buffer alternate-window). (default nil)
   dotspacemacs-enable-cycling nil

   ;; Whether side windows (such as those created by treemacs or neotree)
   ;; are kept or minimized by `spacemacs/toggle-maximize-window' (SPC w m).
   ;; (default t)
   dotspacemacs-maximize-window-keep-side-windows t

   ;; If nil, no load-hints enabled. If t, enable the `load-hints' which will
   ;; put the most likely path on the top of `load-path' to reduce walking
   ;; through the whole `load-path'. It's an experimental feature to speedup
   ;; Spacemacs on Windows. Refer the FAQ.org "load-hints" session for details.
   dotspacemacs-enable-load-hints nil

   ;; If t, enable the `package-quickstart' feature to avoid full package
   ;; loading, otherwise no `package-quickstart' attemption (default nil).
   ;; Refer the FAQ.org "package-quickstart" section for details.
   dotspacemacs-enable-package-quickstart nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default t) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' to obtain fullscreen
   ;; without external boxes. Also disables the internal border. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes the
   ;; transparency level of a frame background when it's active or selected. Transparency
   ;; can be toggled through `toggle-background-transparency'. (default 90)
   dotspacemacs-background-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode t

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `ack' and `grep'.
   ;; (default '("rg" "ag" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "ack" "grep")

   ;; The backend used for undo/redo functionality. Possible values are
   ;; `undo-redo', `undo-fu' and `undo-tree' see also `evil-undo-system'.
   ;; Note that saved undo history does not get transferred when changing
   ;; your undo system from or to undo-tree. (default `undo-redo')"
   dotspacemacs-undo-system 'undo-redo

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Color highlight trailing whitespace in all prog-mode and text-mode derived
   ;; modes such as c++-mode, python-mode, emacs-lisp, html-mode, rst-mode etc.
   ;; (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; The variable `global-spacemacs-whitespace-cleanup-modes' controls
   ;; which major modes have whitespace cleanup enabled or disabled
   ;; by default.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y nil

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env)
  )

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  ;; After initial setup - more balanced settings
  (setq url-queue-parallel-processes 2)  ; Allow some parallelism
  (setq url-queue-timeout 30)

  (when (boundp 'native-comp-async-jobs-number)
    (setq native-comp-async-jobs-number 2))  ; Or half your CPU cores
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."

  ;; ============================================================
  ;; GTD System Configuration
  ;; ============================================================

  ;; *** CHANGE THIS PATH FOR ONEDRIVE SYNC ***
  ;; Examples:
  ;;   Windows OneDrive: "C:/Users/user/OneDrive/org"
  ;;   Mac OneDrive:     "~/Library/CloudStorage/OneDrive-Personal/org"
  ;;   Local:            "~/org"
  (defvar my/org-directory "~/org"
    "Root directory for all org files. Change this for OneDrive sync.")

  ;; Helper function to build paths relative to org directory
  (defun my/org-file (path)
    "Return absolute path for PATH relative to `my/org-directory'."
    (expand-file-name path my/org-directory))

  ;; Set org directory
  (setq org-directory my/org-directory)

  ;; Org files for agenda
  (setq org-agenda-files (list (my/org-file "inbox.org")
                               (my/org-file "projects.org")
                               (my/org-file "journal/")))

  ;; TODO keywords with fast selection
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)" "MOVED(m)")))

  ;; TODO keyword faces
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "#ff6b6b" :weight bold))
          ("NEXT" . (:foreground "#ffd93d" :weight bold))
          ("WAITING" . (:foreground "#c8d6e5" :weight bold))
          ("DONE" . (:foreground "#6bcb77" :weight bold))
          ("CANCELLED" . (:foreground "#808080" :weight bold))
          ("MOVED" . (:foreground "#a29bfe" :weight bold))))

  ;; Enable logging
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-clock-into-drawer t)

  ;; Refile targets
  (setq org-refile-targets `((org-agenda-files :maxlevel . 3)
                             (,(my/org-file "someday.org") :maxlevel . 2)
                             (,(my/org-file "archive.org") :maxlevel . 1)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)

  ;; Archive location
  (setq org-archive-location (concat (my/org-file "archive.org") "::datetree/"))

  ;; Capture templates (using backquote for dynamic path evaluation)
  (setq org-capture-templates
        `(("t" "Todo" entry (file ,(my/org-file "inbox.org"))
           "* TODO %?\nCaptured: %U\n")
          ("n" "Note" entry (file+headline ,(my/org-file "inbox.org") "Notes")
           "* %?\nCaptured: %U\n")
          ("j" "Journal Entry" entry (file+function ,(my/org-file "journal/") my/org-journal-find-location)
           "**** Notes\n%?\n" :empty-lines 1)
          ("d" "Daily Todo" entry (file+function ,(my/org-file "journal/") my/org-journal-find-location-todo)
           "***** TODO %?\nSCHEDULED: %t\n" :empty-lines 0)
          ("w" "Weekly Review" entry (file+headline ,(my/org-file "review/weekly.org") ,(format-time-string "%Y"))
           "*** Week %(format-time-string \"%V\") (%(format-time-string \"%Y-%m-%d\"))\n**** What went well?\n%?\n**** What could be improved?\n**** Key accomplishments\n**** Incomplete items to carry forward\n**** Goals for next week\n")
          ("m" "Monthly Review" entry (file+headline ,(my/org-file "review/monthly.org") ,(format-time-string "%Y"))
           "*** %(format-time-string \"%B %Y\")\n**** Monthly Goals Review\n%?\n**** Key Achievements\n**** Challenges Faced\n**** Lessons Learned\n**** Areas for Improvement\n**** Goals for Next Month\n")))

  ;; Custom agenda views
  (setq org-agenda-custom-commands
        '(("d" "Daily View"
           ((agenda "" ((org-agenda-span 'day)
                        (org-agenda-start-day nil)))
            (todo "NEXT" ((org-agenda-overriding-header "Next Actions")))
            (todo "WAITING" ((org-agenda-overriding-header "Waiting For")))))
          ("w" "Weekly View"
           ((agenda "" ((org-agenda-span 'week)
                        (org-agenda-start-on-weekday 1)))
            (todo "TODO" ((org-agenda-overriding-header "All TODOs")))))
          ("p" "Projects" tags-todo "+project")
          ("i" "Inbox" tags "inbox")))

  ;; ============================================================
  ;; Helper Functions for Journal
  ;; ============================================================

  (defun my/get-journal-file-for-date (date)
    "Get the journal file path for DATE."
    (let ((year (format-time-string "%Y" date)))
      (my/org-file (concat "journal/" year ".org"))))

  (defun my/get-journal-file-today ()
    "Get today's journal file."
    (my/get-journal-file-for-date (current-time)))

  (defun my/ensure-journal-header (file year)
    "Ensure FILE has proper header for YEAR."
    (unless (file-exists-p file)
      (with-temp-file file
        (insert (format "#+TITLE: Journal %s\n" year))
        (insert "#+FILETAGS: :journal:\n")
        (insert "#+STARTUP: overview\n")
        (insert "#+TODO: TODO(t) NEXT(n) WAITING(w) | DONE(d) CANCELLED(c) MOVED(m)\n\n")
        (insert (format "* %s\n" year)))))

  (defun my/org-journal-find-location ()
    "Find or create today's journal entry for capture."
    (let* ((date (current-time))
           (file (my/get-journal-file-today))
           (year (format-time-string "%Y" date))
           (month-name (format-time-string "%Y-%m %B" date))
           (day-name (format-time-string "%Y-%m-%d %A" date)))
      (my/ensure-journal-header file year)
      (set-buffer (org-capture-target-buffer file))
      (goto-char (point-min))
      ;; Find or create year heading
      (unless (re-search-forward (format "^\\* %s$" year) nil t)
        (goto-char (point-max))
        (insert (format "\n* %s\n" year)))
      ;; Find or create month heading
      (unless (re-search-forward (format "^\\*\\* %s$" month-name) nil t)
        (org-end-of-subtree t t)
        (insert (format "** %s\n" month-name)))
      ;; Find or create day heading
      (unless (re-search-forward (format "^\\*\\*\\* %s$" day-name) nil t)
        (org-end-of-subtree t t)
        (insert (format "*** %s\n" day-name))
        (insert "**** Daily Plan\n")
        (insert "**** Notes\n")
        (insert "**** Time Log\n:LOGBOOK:\n:END:\n"))
      ;; Go to end of day entry
      (org-end-of-subtree t)))

  (defun my/org-journal-find-location-todo ()
    "Find location for daily todo capture."
    (my/org-journal-find-location)
    (re-search-backward "^\\*\\*\\*\\* Daily Plan$" nil t)
    (org-end-of-subtree t))

  ;; ============================================================
  ;; BONUS: Open Today's Note
  ;; ============================================================

  (defun my/open-today-note ()
    "Open today's journal entry, creating the day's structure if needed."
    (interactive)
    (let* ((date (current-time))
           (file (my/get-journal-file-today))
           (year (format-time-string "%Y" date))
           (month-name (format-time-string "%Y-%m %B" date))
           (day-name (format-time-string "%Y-%m-%d %A" date)))
      (my/ensure-journal-header file year)
      (find-file file)
      (goto-char (point-min))
      ;; Find or create year heading
      (unless (re-search-forward (format "^\\* %s$" year) nil t)
        (goto-char (point-max))
        (insert (format "\n* %s\n" year)))
      ;; Find or create month heading
      (unless (re-search-forward (format "^\\*\\* %s$" month-name) nil t)
        (org-end-of-subtree t t)
        (insert (format "** %s\n" month-name)))
      ;; Find or create day heading
      (if (re-search-forward (format "^\\*\\*\\* %s$" day-name) nil t)
          (progn
            (beginning-of-line)
            (org-show-subtree))
        (org-end-of-subtree t t)
        (insert (format "*** %s\n" day-name))
        (insert "**** Daily Plan\n")
        (insert "**** Notes\n")
        (insert "**** Time Log\n:LOGBOOK:\n:END:\n")
        (re-search-backward (format "^\\*\\*\\* %s$" day-name) nil t)
        (org-show-subtree))
      (message "Opened journal for %s" day-name)))

  ;; ============================================================
  ;; BONUS: Move TODO to Another Day
  ;; ============================================================

  (defun my/move-todo-to-date (target-date)
    "Move the current TODO item to TARGET-DATE in the journal.
  Marks current item as MOVED and creates a copy at the target date."
    (interactive (list (org-read-date nil t nil "Move to date: ")))
    (unless (org-entry-is-todo-p)
      (user-error "Not on a TODO item"))
    (let* ((todo-text (org-get-heading t t t t))
           (todo-state (org-get-todo-state))
           (todo-body (save-excursion
                        (org-back-to-heading t)
                        (let ((beg (point)))
                          (org-end-of-subtree t)
                          (buffer-substring-no-properties
                           (save-excursion
                             (goto-char beg)
                             (forward-line 1)
                             (point))
                           (point)))))
           (target-file (my/get-journal-file-for-date target-date))
           (target-year (format-time-string "%Y" target-date))
           (target-month (format-time-string "%Y-%m %B" target-date))
           (target-day (format-time-string "%Y-%m-%d %A" target-date))
           (target-scheduled (format-time-string "<%Y-%m-%d %a>" target-date)))
      ;; Mark current todo as MOVED
      (org-todo "MOVED")
      (org-set-property "MOVED-TO" (format-time-string "%Y-%m-%d" target-date))
      ;; Create the todo at target date
      (my/ensure-journal-header target-file target-year)
      (with-current-buffer (find-file-noselect target-file)
        (goto-char (point-min))
        ;; Find or create year
        (unless (re-search-forward (format "^\\* %s$" target-year) nil t)
          (goto-char (point-max))
          (insert (format "\n* %s\n" target-year)))
        ;; Find or create month
        (unless (re-search-forward (format "^\\*\\* %s$" target-month) nil t)
          (org-end-of-subtree t t)
          (insert (format "** %s\n" target-month)))
        ;; Find or create day
        (unless (re-search-forward (format "^\\*\\*\\* %s$" target-day) nil t)
          (org-end-of-subtree t t)
          (insert (format "*** %s\n" target-day))
          (insert "**** Daily Plan\n")
          (insert "**** Notes\n")
          (insert "**** Time Log\n:LOGBOOK:\n:END:\n"))
        ;; Find Daily Plan section
        (re-search-forward "^\\*\\*\\*\\* Daily Plan$" nil t)
        (org-end-of-subtree t)
        ;; Insert the todo
        (insert (format "\n***** %s %s\nSCHEDULED: %s\n%s"
                        todo-state todo-text target-scheduled todo-body))
        (save-buffer))
      (message "Moved '%s' to %s" todo-text target-day)))

  (defun my/move-todo-to-tomorrow ()
    "Move the current TODO to tomorrow."
    (interactive)
    (my/move-todo-to-date (time-add (current-time) (days-to-time 1))))

  (defun my/move-todo-to-next-week ()
    "Move the current TODO to next week (same weekday)."
    (interactive)
    (my/move-todo-to-date (time-add (current-time) (days-to-time 7))))

  ;; ============================================================
  ;; Keybindings
  ;; ============================================================

  ;; Leader key bindings under SPC o (org/custom)
  (spacemacs/declare-prefix "o" "org/gtd")
  (spacemacs/set-leader-keys
    "oj" 'my/open-today-note           ; Open today's journal
    "om" 'my/move-todo-to-date         ; Move todo to specific date
    "ot" 'my/move-todo-to-tomorrow     ; Move todo to tomorrow
    "ow" 'my/move-todo-to-next-week    ; Move todo to next week
    "oc" 'org-capture                  ; Quick capture
    "oa" 'org-agenda                   ; Agenda view
    "or" 'org-refile                   ; Refile item
    "ol" 'org-store-link               ; Store link
    "oi" 'org-clock-in                 ; Clock in
    "oO" 'org-clock-out                ; Clock out
    "og" 'org-clock-goto)              ; Go to clocked task

  ;; ============================================================
  ;; Additional Org Settings
  ;; ============================================================

  ;; Show deadlines and scheduled items in agenda
  (setq org-agenda-include-deadlines t)
  (setq org-deadline-warning-days 7)

  ;; Clock settings
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)
  (setq org-clock-history-length 25)
  (setq org-clock-report-include-clocking-task t)

  ;; Pretty display
  (setq org-ellipsis " ▼")
  (setq org-hide-emphasis-markers t)
  (setq org-startup-indented t)
  (setq org-startup-folded 'content)

  ;; Calendar integration
  (setq calendar-week-start-day 1)  ; Start week on Monday

  )


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
