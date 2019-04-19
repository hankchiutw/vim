fish_vi_key_bindings
function fish_user_key_bindings
  # Can use ctrl+[ to escape by default or you can set binding like 'kj'
  # bind -M insert -m default kj backward-char force-repaint
  for mode in insert default visual
    # Use ctrl+f to accept auto suggestion
    bind -M $mode \cf forward-char
    
    # Enable all Emacs mode key binding in vi mode
    # fish_default_key_bindings -M $mode
  end
end
