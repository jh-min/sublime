# `sublime`

**Program to set up [StataEditor][3] (a package of Sublime Text) automatically**

`sublime` automates the installation process of `StataEditor`, a Sublime Text package enabling Stata users to interactively send code to Stata from Sublime Text. After getting `StataEditor` and `Pywin32` via Package Control, *to run Stata and execute this command* will finish the setup of `StataEditor`.

What does `sublime` do for you in detail? `sublime` automatically detects the version of current Stata session, locates Sublime Text directory, writes the settings file for `StataEditor` and registers [the Stata Automation type library][1]. Note that you might have to `run Stata as Administrator` to register the Stata Automation type library.

[3]: <https://github.com/mattiasnordin/StataEditor>
[1]: <https://www.stata.com/automation/#createmsapp>


## Installation

You can install `sublime` using either Stata’s `net install` command or user-written package [github][5].
```
net from https://raw.githubusercontent.com/jh-min/sublime/master
github install jh-min/sublime
```

[5]: <https://github.com/haghish/github>

### Known issue(s)

- `StataEditor` opens new Stata session every time and does not send code to Stata!
> This problem lies in the failure to register the Stata Automation type library. If you are using Windows 10, please execute `sublime` with `Stata running as Administrator`. If you are using Windows 7/8/Vista, you might need to follow the Windows Vista instruction which can be found [here][1].


## Syntax

```
sublime [, options]
```

otpions | Description
---|:---
***i****nstalled* | set `StataEditor` assuming Sublime Text is installed on user’s system
***p****ortable* | set `StataEditor` assuming the path to portable version of Sublime Text is stored with `whereis`
***keep****whereis* | force `sublime` not to remove the entry named `Sublime` from `whereis`
***m****anually* | write the settings file for `StataEditor` in current working directory

By default, `sublime` will locate the directory of Sublime Text assuming that Sublime Text is installed on your system. If `sublime` fails to locate the directory of installed version, it will use the path stored with SSC package [whereis][4] assuming that you are using portable version of Sublime Text. Then `sublime` will write the settings file for `StataEditor` in that directory.

If `installed` is specified, `sublime` will not depend on `whereis` even if it fails to locate the installed version of Sublime Text.

If `portable` is specified, `sublime` will depend on `whereis` even if Sublime Text is installed on your system. To specify this option, you should first install `whereis` from SSC archive and then create an entry named `Sublime` to store the location of portable version as follows:
```s
whereis Sublime "path/to/portable version/sublime_text.exe"
```

By default, if you have specified `portable` while the path stored with `whereis` is indeed *not the location of portable version*, `sublime` will automatically remove the entry named `Sublime` from `whereis`. If you don’t want this behavior, specify `keepwhereis`.

If `manually` is specified, `sublime` will not locate the directory of Sublime Text and just write the settings file for `StataEditor` in current working directory. You might manually move this file to your Sublime Text directory to set `StataEditor`.


## Author

[JeongHoon Min][2], Sogang University, plus1@sogang.ac.kr

[2]: <https://jhmin.weebly.com>


## Acknowledgement

The author is grateful to Germán Rodríguez for the [whereis][4] program.

[4]: <https://ideas.repec.org/c/boc/bocode/s458303.html>