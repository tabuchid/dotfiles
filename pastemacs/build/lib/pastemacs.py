# -*- coding: utf-8 -*-
# allows pasting the current buffer on paste.pocoo.org
# Copyright (c) 2007, 2008, 2009 Sebastian Wiesner <basti.wiesner@gmx.net>

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.


"""
    paste
    =====

    This pymacs module provides a handful of function for convenient access
    to the pastebin at `http://paste.pocoo.org`.


    :copyright: 2008 by Sebastian Wiesner
    :license: GPL-2
"""


# TODO: add proper error handling to avoid exception tracebacks
# TODO: provide customisation to map pastebin languages to major modes


from Pymacs import lisp

from lodgeitlib import lodgeit


# necessary references
lisp.require(lisp['easymenu'])
lisp.require(lisp['browse-url'])


# customisation group
# XXX: maybe this could somehow be written in python
lisp("""
(defgroup pastebin nil
  "Access to the pastebin on paste.pocoo.org"
  :group 'convenience)

(defcustom paste-kill-url nil
  "*If non-nil, put the url of a new paste into kill ring"
  :group 'pastebin
  :type 'boolean)

(defcustom paste-show-in-browser nil
  "*If non-nil, invoke the browser with the paste url after
  pasting a new snippet"
  :group 'pastebin
  :type 'boolean)
""")


## lodgeit wrappers which add some messaging
def new_paste(code, language, filename):
    """Creates a new paste."""
    lisp.message('Transferring paste to server...')
    id = lodgeit.new_paste(code, language, filename=filename)
    paste = lodgeit.get_paste_by_id(id)
    lisp.message(
        'New paste with id {0.id} created. Refer to {0.url}'.format(paste))
    if lisp.paste_kill_url.value():
        lisp.kill_new(paste.url)
    if lisp.paste_show_in_browser.value():
        lisp.browse_url(paste.url)


def languages():
    """Returns a list of supported languages."""
    if not lodgeit.has_languages:
        lisp.message('Fetching list of supported languages from server')
    return lodgeit.languages.keys()


## NON-INTERACTIVE FUNCTIONS
# interactive argument completion
def read_language():
    """Reads a paste language from minibuffer. Provides completion based on
    the list ov available languages"""
    # guess language from major mode
    major_mode = lisp.major_mode.value().text
    def_language = major_mode[:-5]
    if def_language not in languages():
        def_language = 'text'
    msg = 'Language of paste snippet ({0}): '.format(def_language)
    language = (lisp.completing_read(msg, languages()).strip()
                or def_language)
    return language


def get_new_from_region_args():
    """Gets args for new_from_region:
    The language and the currently active region"""
    lang = read_language()
    start, end = lisp.region_beginning(), lisp.region_end()
    return [start, end, lang]


def get_new_from_buffer_args():
    """Gets args for new_from_buffer:
    The paste language"""
    buff = lisp.read_buffer('Buffer to paste: ',
                            lisp.current_buffer(), True)
    lang = read_language()
    return [buff, lang]


def new_buffer_from_paste(paste):
    """Creates a new buffer from `paste`"""
    lisp.switch_to_buffer('paste {0.id}'.format(paste))
    lisp.erase_buffer()
    lisp.insert(paste.code)
    # simple guessing of the buffer mode
    # XXX: is there a better way?
    # FIXME: do at least a bit of error handling and check, if there is such a mode
    mode = lisp['{0.language}-mode'.format(paste)]
    mode()


## INTERACTIVE FUNCTIONS
# to fetch pastes
def fetch_by_id(paste_id):
    """Fetches paste with `paste_id` and inserts it into a new buffer"""
    paste = lodgeit.get_paste_by_id(paste_id)
    if paste:
        new_buffer_from_paste(paste)
    else:
        lisp.error('There is no paste with id'.format(paste_id))
fetch_by_id.interaction = ('nThe paste id: ')


def insert_by_id(paste_id):
    """Fetches paste with `paste_id` and inserts it into current buffer"""
    paste = lodgeit.get_paste_by_id(paste_id)
    if paste:
        lisp.insert(paste.code)
    else:
        lisp.error('There is no paste with id {0}'.format(paste_id))
insert_by_id.interaction = ('*nThe paste id: ')


def fetch_last():
    """Fetches last paste and inserts it into a new buffer"""
    paste = lodgeit.get_last_paste()
    new_buffer_from_paste(paste)
fetch_last.interaction = ''


def insert_last():
    """Inserts the last paste into current buffer"""
    paste = lodgeit.get_last_paste()
    lisp.insert(paste.code)
insert_last.interaction = '*'


# to create new pastes
def new_from_region(start, end, language):
    """Pastes the current selection"""
    code = unicode(lisp.buffer_substring(start, end))
    filename = lisp.buffer_file_name()
    new_paste(code, language, filename=filename)
new_from_region.interaction = get_new_from_region_args

def new_from_buffer(buffer, language):
    """Pastes the contents of buffer"""
    lisp.set_buffer(buffer)
    code = unicode(lisp.buffer_string())
    #code = lisp.buffer_substring(lisp.point_min(), lisp.point_max())
    filename = lisp.buffer_file_name()
    new_paste(code, language, filename=filename)
new_from_buffer.interaction = get_new_from_buffer_args


def menu():
    """Creates a global menu to access the pastebin functionality"""
    lisp.easy_menu_add_item(
        lisp.current_global_map(),
        ['menu-bar'],
        ['Pastebin',
         ('Fetch last', lisp.paste_fetch_last),
         ('Insert last', lisp.paste_insert_last),
         ('Fetch by id', lisp.paste_fetch_by_id),
         ('Insert by id', lisp.paste_insert_by_id),
         '---',
         ('New from buffer', lisp.paste_new_from_buffer),
         ('New from region', lisp.paste_new_from_region)
         ])
menu.interaction = ''
