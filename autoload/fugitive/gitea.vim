function! fugitive#gitea#browse_handler(opts, ...) abort
  if a:0 || type(a:opts) != type({})
    return ''
  endif

  let domains = g:fugitive_gitea_domains
  let domain_patterns = []
 
  for domain in domains
    call add(domain_patterns, escape(split(domain, '://')[-1], '.'))
  endfor

  let domain_pattern = join(domain_patterns, '\|')
  let repo = matchstr(a:opts.remote,'^\%(https\=://\|git://\|\(ssh://\)\=\a\+@\)\%(.\{-\}@\)\=\zs\('.domain_pattern.'\)[/:].\{-\}\ze\%(\.git\)\=$')
  if repo ==# ''
    return ''
  endif

  if match(a:opts.remote, 'ssh://') >= 0
      let repo = substitute(repo, ':\d\+', '', '')
  endif

  if match(a:opts.remote, '\a\+@') >= 0
      let repo = substitute(repo, ':', '/', '')
  endif

  if index(domains, 'http://' . matchstr(repo, '^[^:/]*')) >= 0
    let root = 'http://'.repo
  else
    let root = 'https://'.repo
  endif

  let path = substitute(a:opts.path, '^/', '', '')
  if path =~# '^\.git/refs/heads/'
    return root . '/commits/'.path[16:-1]
  elseif path =~# '^\.git/refs/tags/'
    return root . '/src/'.path[15:-1]
  elseif path =~# '.git/\%(config$\|hooks\>\)'
    return root . '/admin'
  elseif path =~# '^\.git\>'
    return root
  endif
  if a:opts.commit =~# '^\d\=$'
    let commit = a:opts.repo.rev_parse('HEAD')
  else
    let commit = a:opts.commit
  endif
  if get(a:opts, 'type', '') ==# 'tree' || a:opts.path =~# '/$'
    return ''
  elseif get(a:opts, 'type', '') ==# 'blob' || a:opts.path =~# '[^/]$'
    let url = root . '/src/'.commit.'/'.path
    if get(a:opts, 'line1')
      let url .= '#L' . a:opts.line1
      if get(a:opts, 'line2') != get(a:opts, 'line1')
        let url .= '-L' . a:opts.line2
      endif
    endif
  else
    let url = root . '/commit/' . commit
  endif
  return url
endfunction

