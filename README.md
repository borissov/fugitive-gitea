# fugitive-gitea

## Installation

Via Plugin Manager
#### Vundle
```viml
    Plugin 'borissov/fugitive-gitea'
```
#### VIM Plug 
```viml
    Plug 'borissov/fugitive-gitea'
```
### Manual Installation
```bash
cd ~/.vim/bundle
git clone git://github.com/borissov/fugitive-gitea
```

## Settings
In your .vimrc file add options to set your Gitea server urls.

```viml
let g:fugitive_gitea_domains = ['http://yoururl.com'] 
```


### Originaly from
tommcdo/vim-fubitive
