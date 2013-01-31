if exists("loaded_java_syntax_checker")
    finish
endif
let loaded_java_syntax_checker = 1

" Location of the checkstyle-all jar file
if !exists("Checkstyle_Classpath")
    let Checkstyle_Classpath = '/opt/checkstyle/checkstyle-all-3.1.jar'
endif

if !exists("Checkstyle_XML")
    let Checkstyle_XML = '/opt/checkstyle/contrib/examples/conf/BlochEffectiveJava.xml'
endif

function! SyntaxCheckers_java_GetLocList()
    let filename = expand("%:p")
    let makeprg  = 'java -cp ' . g:Checkstyle_Classpath
    let makeprg  = makeprg  . ' com.puppycrawl.tools.checkstyle.Main'
    let makeprg  = makeprg  . ' -c ' . g:Checkstyle_XML
    let makeprg  = makeprg  . ' ' . filename
    let errorformat='%f:%l:%v: %m,%f:%l: %m,%-G%.%#'
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction
