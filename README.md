# C++ class to PlantUML class entity converter

Utility to convert a C++ class header to (somewhat syntantically correct) PlantUML class entity syntax


## Usage

Execute the programm with provided C++ header or source file

        ./preprocess_cpp_header_for_plantuml.sh /home/laptop/git/kyberdrb/clean_pacman_cache_dir/LocallyInstalledPackage.h

The output file is printed on the screen an its content copied to the clipboard for further processing in PlantUML class diagram.

## Specification

- https://duckduckgo.com/?q=c%2B%2B+ascii+uml&ia=web
- to ASCII-art output?
- to PlantUML syntax? and then let PlantUML generate the graphic representation of the UML diagram
- Algorithm
    1. Create a duplicate file from the original (header/implementation) file

            cp /path/to/original/file.extension /tmp/file.extension.puml.preprocessed

        e.g.

            cp /home/laptop/git/kyberdrb/clean_pacman_cache_dir/LocallyInstalledPackage_refactored_.h /tmp/LocallyInstalledPackage_refactored_.h.puml.preprocessed

    1. scan all header files
        - delete all comments
            - delete all lines that contain `//` `/*` or `*/`

                    sed '/^\s*\/\/.*/d' LocallyInstalledPackage_refactored_.h

            - delete all lines that contain `/*` or `*/` and everything in between

                    ???

        - delete all `includes` from standard library
            - delete all lines that contain `#include <`

                    sed '/^\s*#include </d' LocallyInstalledPackage_refactored_.h

        - delete all `pragma` directives
            - delete all lines that contain `#pragma`

                    sed '/^\s*#pragma/d' LocallyInstalledPackage_refactored_.h

        - delete all `const`/`volatile`/`explicit`/`friend`/`override`/`;` (semicolons)
            - replace all mentioned keywords with empty string

                    sed 's/const//g' LocallyInstalledPackage_refactored_.h
                    sed 's/volatile//g' LocallyInstalledPackage_refactored_.h
                    sed 's/explicit//g' LocallyInstalledPackage_refactored_.h
                    sed 's/friend//g' LocallyInstalledPackage_refactored_.h
                    sed 's/override//g' LocallyInstalledPackage_refactored_.h
                    sed 's/;//g' LocallyInstalledPackage_refactored_.h

        - delete all function bodies
        - delete the `public:` scope specifier and append a plus sign `+` to all functions and member variables mentioned after the declaration, until a different scope specifier appears or we reach EOF 
        - delete the `protected:` scope specifier and append a pound sign/hashtag `#` to all functions and member variables mentioned after the declaration, until a different scope specifier appears or we reach EOF 
        - delete the `private:` scope specifier and append a minus sign `-` to all functions and member variables mentioned after the declaration, until a different scope specifier appears or we reach EOF
        - replace all `virtual` keywords with `{abstract}` modifier

                sed 's/virtual/\{abstract\}/g' Package_refactored_.h

        - replace all `#include "path/to/some/file"` with association/composition relationship based on member variable type
            - reference/reference_wrapper/weak_ptr/raw pointer without delete in destructor for association
            - unique_ptr/shared_ptr, raw pointer with delete in destructor for composition)
            together with the cardinality of the relationship
            - member variable of a single type for cardinality 0..1 or 1
            - member variable of a container type for cardinality 0..* or 0..N (where N is a finite decimal number) or 0..*
        - replace colon for inheritance and the `include` preprocessor directive matching with the header file containing the base class with matching name, with a transcript for inheritance relationship  
            from C++ code

                #include "Package_refactored_.h"

                ...

                class PackageWithInferredName_refactored_ : public Package_refactored_ {
                    ...
                }

            to PlantUML syntax

                class PackageWithInferredName_refactored_ {
                    ...
                }

                ...

                Package_refactored_ <|- PackageWithInferredName_refactored_

        - remove pointers and references of any kind

                ??? * & std::unique_ptr std::shared_ptr std::reference_wrapper std::ref

        - remove `std::` namespace prefix

                ???

## Sources

- https://www.2daygeek.com/linux-remove-delete-lines-in-file-sed-command/
- https://stackoverflow.com/questions/32760843/delete-lines-by-pattern-in-specific-range-of-lines/32760970#32760970
- https://duckduckgo.com/?t=ffab&q=sed+replace+multiple+strings&ia=web&iax=qa
- https://duckduckgo.com/?t=ffab&q=sed+remove+blank+lines&ia=web
- https://stackoverflow.com/questions/16414410/delete-empty-lines-using-sed#16414483
- https://duckduckgo.com/?t=ffab&q=sed+remove+beginning+end+but+keep&ia=web
- https://stackoverflow.com/questions/44003133/using-sed-remove-everything-before-the-first-occurence-of-a-character
- https://duckduckgo.com/?t=ffab&q=sed+capture+group&ia=web
- https://linuxhint.com/sed-capture-group-examples/
- https://duckduckgo.com/?t=ffab&q=sed+remove+braces+but+keep+everything+between+them&ia=web
- https://www.codegrepper.com/code-examples/shell/sed+only+keep+string+between+brackets
- https://duckduckgo.com/?t=ffab&q=sed+delete+between+braces&ia=web
- https://unix.stackexchange.com/questions/14838/sed-one-liner-to-delete-everything-between-a-pair-of-brackets
- https://stackoverflow.com/questions/10558826/remove-everything-between-pairs-of-braces-with-sed
- https://duckduckgo.com/?t=ffab&q=sed+replace+character+with+newline&ia=web
- https://stackoverflow.com/questions/16565487/how-do-i-replace-characters-with-newline
- https://unix.stackexchange.com/questions/114943/can-sed-replace-new-line-characters
- https://unix.stackexchange.com/questions/114943/can-sed-replace-new-line-characters#114948
- https://dzone.com/articles/sed-replacing-characters-new
- https://duckduckgo.com/?q=sed+replace+multiple+characters+string+with+newline&t=ffab&ia=web
- https://unix.stackexchange.com/questions/526914/replacing-several-characters-with-newline
- https://duckduckgo.com/?t=ffab&q=sed+replace+end+of+line+with+newline&ia=web
- https://stackoverflow.com/questions/18271110/sed-replacing-end-of-line
- https://duckduckgo.com/?q=sed+replace+character+with+newline+posix&t=ffab&ia=web
- https://www.unix.com/shell-programming-and-scripting/144664-using-sed-i-want-replace-space-newline.html
- https://duckduckgo.com/?t=ffab&q=sed+match+parentheses&ia=web
- https://stackoverflow.com/questions/24136296/matching-pattern-containing-parentheses-with-sed

