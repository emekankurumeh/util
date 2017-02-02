import insert, remove from table
unpack = table.unpack or unpack
pack = (...) -> {...} 

class list
  new: (...) =>
    @length = 0
    @_head = nil
    @_tail = nil
    for t in *{...}
      @push t 
  
  push: (t) =>
    unless type(t) == 'table' t = pack t
    if @_tail
      @_tail._next = t
      t._prev = @_tail
      @_tail = t
    else
      @_head = t
      @_tail = t

    @length += 1

  head: =>
    if not @_head then return
    ret = @_head
    if ret._next 
      ret._next._prev = nil
      @_head = ret._next
      ret._next = nil
    else
      @_head = nil
      @_tail = nil

    @length -= 1
    unpack ret
  
  tail: =>
    if not @_tail then return
    ret = @_tail
    
    if ret._prev 
      ret._prev._next = nil
      @_tail = ret._prev
      ret._prev = nil
    else
      @_head = nil
      @_tail = nil

    @length -= 1
    unpack ret

  insert: (t,a) =>
    if a
      if a._next
        a._next._prev = t
        t._next = a._next
      else
        @_tail = t

      t._prev = a
      a._next = t
      @length += 1
      
    elseif not @_head
      @_head = t
      @_tail = t

  remove: (t) =>
    if t._next
      if t._prev
        t._next._prev = t._prev
        t._prev._next = t._next
      else
        t._next._prev = nil
        @_head = t._next
        
    elseif t._prev
      t._prev._next = nil
      @_tail = t._prev
      
    else
      @_head = nil
      @_tail = nil

    t._next = nil
    t._prev = nil
    @length -= 1

  map: (f,...) =>
    clone = @clone!
    local _head, tmp, c
    _head = clone._head
    c = {}
    for _ in *clone
      tmp = _head
      if tmp._next 
        _head = tmp._next
      else
        _head = nil
      insert c, f unpack(tmp), ...

    return list unpack c

  each: =>
    clone = @clone!
    local _head, tmp, c
    _head = clone._head
    c = {}
    for _ in *@
      tmp = _head
      if tmp._next 
        _head = tmp._next
      else
        _head = nil
      insert c, unpack tmp

    return ipairs c

  clone: =>
    local _head, tmp, c
    _head = @_head
    c = {}
    for _ in *@
      tmp = _head
      if tmp._next 
        _head = tmp._next
      else
        _head = nil
      insert c, unpack tmp

    list unpack c

  __len: =>
    @length

{:list}