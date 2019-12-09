*** 7Dec2019
*** contact information: plus1@sogang.ac.kr

qui {

*** memorize cd
	local current "`c(pwd)'"

*** move to Sublime directory
	capture macro drop _sldir
	capture whereis Sublime
	if "`r(Sublime)'"!="" {
	* depend on whereis command
		local sldir "`r(Sublime)'"
		local sldir=subinstr("`sldir'", "\", "/", .)
		local sldir=substr("`sldir'", 1, strlen("`sldir'")-17)
		capture cd "`sldir'/Data/Packages/User"
		if _rc!=0 {
		* whereis command might have stored the directory of non-portable version
			cd "`c(sysdir_plus)'\w"
			file open wdir using "whereis.dir" , read
			file read wdir line
			local lines1 "`line'"
			local i=2
			while r(eof)==0 {
				file read wdir line
				local lines`i' "`line'"
				local i=`i'+1
			}
			file close wdir
			erase "whereis.dir"
			file open wdirnew using "whereis.dir" , write text replace
			local j=1
			while `j'<`i'-1 {
				if strmatch("`lines`j''", "Sublime*")!=1 {
					file write wdirnew `"`lines`j''"' _n
				}
				local j=`j'+1
			}
			file close wdirnew
			cd "`current'"
			di as error "Please re-execute this do-file"
			exit 601
		}
	}
	else {
	* depend on environment variable %APPDATA%
		local sldir : environ APPDATA
		local sldir=subinstr("`sldir'", "\", "/", .)
		if strmatch("`sldir'", "*/")==1 {
			local sldir=substr("`sldir'", 1, strlen("`sldir'")-1)
		}
		capture cd "`sldir'/Sublime Text 3/Packages/User"
		if _rc!=0 {
		* depend on environment variable %USERPROFILE%
			local sldir : environ USERPROFILE
			local sldir=subinstr("`sldir'", "\", "/", .)
			if strmatch("`sldir'", "*/")==1 {
				local sldir=substr("`sldir'", 1, strlen("`sldir'")-1)
			}
			capture cd "`sldir'/AppData/Roaming/Sublime Text 3/Packages/User"
			if _rc!=0 {
			* Sublime Text seems not to be installed
				noisily mata: printf("{cmd}Sublime Text{error} could not be found on your system\n")
				noisily mata: printf("{text}If you are using {result}portable version{text} of {cmd}Sublime Text{text},\n")
				noisily mata: printf("{text}please save the directory of {cmd}Sublime Text{text} with ssc package {cmd}whereis{text} as follows:\n")
				noisily mata: printf(`"{result}. whereis Sublime "path/to/Sublime Text/sublime_text.exe"\n"')
				cd "`current'"
				exit 601
			}
		}
	}

*** get Stata info
	capture macro drop _statabit _statafl _stataver _fws_dir
	if `c(bit)'==64 {
		local statabit "-`c(bit)'"
	}
	if `c(MP)'==1 {
		local statafl "StataMP"
	}
	else if `c(SE)'==1 {
		local statafl "StataSE"
	}
	else if "`c(flavor)'"=="IC" {
		local statafl "Stata"
	}
	else {
		local statafl "smStata"
	}
	local stataver=round(`c(stata_version)')
	local fws_dir=subinstr("`c(sysdir_stata)'", "\", "/", .)
	if strmatch("`fws_dir'", "*/")!=1 {
		local fws_dir "`fws_dir'/"
	}

*** write sublime-settings
	file open slset using "StataEditor.sublime-settings" , write text replace
	file write slset `"{"' _n
	file write slset `"	"extensions":"' _n
	file write slset `"	["' _n
	file write slset `"		"sthlp","' _n
	file write slset `"		"pkg""' _n
	file write slset `"	],"' _n
	file write slset `"	"stata_path": "`fws_dir'`statafl'`statabit'.exe","' _n
	file write slset `"	"stata_version": `stataver',"' _n
	file write slset `"}"' _n
	file close slset

*** register the Stata Automation type library 
	cd "`c(sysdir_stata)'"
	shell `statafl'`statabit' /Regserver

*** reset cd
	cd "`current'"

}
