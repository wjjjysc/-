# Usage:
#   $QUARTUS_ROOTDIR/bin/quartus_sh -t PATH KEY...
# Where:
#   PATH is the path to this .tcl file.
#   KEY has the format:
#       LANGUAGE#SIMULATOR#[DEVICE_FAMILY]
#
# For each given KEY, a corresponding .spd file is generate, with filename:
#   KEY.spd

package require ::quartus::sim_lib_info

proc translate_filetype filetype {

    set typelist [ list SYSTEMVERILOG VERILOG VHDL ]
    set returnvalue ""

    foreach type $typelist {
        if { [ regexp -nocase $type $filetype ] } {
            set returnvalue $type
            break
        }
    }
    return $returnvalue
}

proc write_file_element { spd filepath filetype library } {

    puts $spd "    <file"
    puts $spd "        path=\"$filepath\""
    puts $spd "        type=\"$filetype\""
    puts $spd "        library=\"$library\""
    puts $spd "    />"
}

proc create_spd_file { filename simulation_library_information } {
    # create spd file and write the root element open tag
    set spd [ open "$filename.spd" w]
    puts $spd "<simPackage>"

    foreach element $simulation_library_information {
       # library of the file to be compiled to
       set librarypath [ lindex $element 0 ]

       # access the list of files fot this library
       set file_list [ lindex $element 1 ]

       foreach filepath_and_type $file_list {
          # access file and its language
          set filepath [ lindex $filepath_and_type 0 ]
          set filetype [ lindex $filepath_and_type 1 ]

          # convert the file type to just systemverilog, verilog or vhdl
          set filetype [ translate_filetype $filetype]

          # dump in each library infos to individual element
          write_file_element $spd $filepath $filetype $librarypath
       }
    }

    # write the root element close tag
    puts $spd "</simPackage>"
    close $spd
}

foreach filename $argv {
    set information [ split $filename "#" ]
    set language [ lindex $information 0 ]
    set simulator [ lindex $information 1 ]
    set device_family [ lindex $information 2 ]

    if { $simulator eq "riviera" } {
        set simulator "rivierapro"
    } elseif { $simulator eq "vcsmx" } {
        set simulator "vcs"
    }

    if { $device_family eq "" } {
        set simulation_library_information [ ::quartus::sim_lib_info::get_family_independent_sim_models $language $simulator ]
    } else {
        set simulation_library_information [ ::quartus::sim_lib_info::get_sim_models_for_family $device_family $language 1 $simulator ]
    }
    create_spd_file $filename $simulation_library_information
}
