
#function -e fish_preexec _run_fasd
#     fasd --proc (fasd --sanitize $argv | tr -s ' ' \n) > /dev/null 2>&1
#end

function f
    fasd -f "$argv"
end

function r
    fasd -fe $argv[1] "$argv[2..-1]"
end
