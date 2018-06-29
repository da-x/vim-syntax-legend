setlocal nocompatible

function! Main() abort
  syntax on

  let l:joint_source_markers_list = []
  let l:legend_dict = {}
  let l:legend_rev_dict = {}
  let l:legend_rev_dict_count = {}
  let l:character_bank = ''
  let l:next_char = 0
  let l:legend_list = []
  let l:prev_file = $VIM_SYNTAX_LEGEND_PREV_FILE

  " Populate keys from previous output legend

  if l:prev_file !=# ''
    let l:prev_output_list = readfile(l:prev_file)

    for l:line in l:prev_output_list
      let l:res = matchlist(l:line, '\V\(\.\) - \(\w\+\)')
      if len(l:res) >= 3
        let l:value = l:res[1]
        let l:key = l:res[2]
        let l:legend_dict[l:key] = l:value
        let l:legend_rev_dict[l:value] = l:key
        let l:legend_rev_dict_count[l:value] = 0
      endif
      if l:line ==# 'Source:'
        break
      endif
    endfor
  endif

  " Create a character bank used for legend keys

  for l:index in range(32, 127)
    let l:char = nr2char(l:index)
    if l:char !=# ' '
      let l:character_bank = l:character_bank . l:char
    endif
  endfor

  " Iterate the entire file

  for l:lnum in range(1, line('$'))
    let l:textline = getline(l:lnum)
    if l:textline ==# '' 
      call add(l:joint_source_markers_list, '')
      continue
    endif
    let l:legend_line = ''

    exe 'norm! ' . l:lnum . 'G$'

    for l:cnum in range(1, col('.'))
      let l:char = strpart(l:textline, l:cnum - 1, 1)
      if l:char ==# ' ' || l:char ==# '\t' || l:char ==# '\n'
        let l:syn = l:char
      else
        let l:id = synID(l:lnum, l:cnum, 0)
        let l:desc = synIDattr(l:id, 'name')
        if string(l:desc) ==# "''"
          let l:desc = '<default>'
        endif

        if !has_key(l:legend_dict, l:desc)
          while 1
            if l:next_char >= len(l:character_bank) 
              " Too many syntax elements!
              throw 'Too many syntax elements!'
            endif
            
            let l:syn = strpart(l:character_bank, l:next_char, 1)
            let l:next_char = l:next_char + 1

            if has_key(l:legend_rev_dict, l:syn)
              continue
            endif

            let l:legend_dict[l:desc] = l:syn
            let l:legend_rev_dict[l:syn] = l:desc
            let l:legend_rev_dict_count[l:syn] = 0
            break
          endwhile
        else
          let l:syn = get(l:legend_dict, l:desc)
        endif

        let l:legend_rev_dict_count[l:syn] += 1
      endif

      let l:legend_line = l:legend_line . l:syn
    endfor

    call add(l:joint_source_markers_list, l:textline)
    call add(l:joint_source_markers_list, l:legend_line)
  endfor

  " Print summary

  let l:output = []
  call add(l:output, 'Legend:')
  call add(l:output, '--------')
  call add(l:output, '')
  call extend(l:output, l:legend_list)

  let l:item_list = []
  for l:key in keys(l:legend_dict)
    call add(l:item_list, [l:key, l:legend_dict[l:key]])
  endfor

  call sort(l:item_list)

  for [l:key, l:value] in l:item_list
    let l:count = l:legend_rev_dict_count[l:value]
    if l:count !=# 0 
      call add(l:output, printf('%s - %-30s', l:value, l:key))
    endif
  endfor
  
  call add(l:output, '')
  call add(l:output, 'Source:')
  call add(l:output, '--------')
  call extend(l:output, l:joint_source_markers_list)

  call writefile(l:output, $VIM_SYNTAX_LEGEND_OUTPUT_FILE)
endfunction

call Main()
