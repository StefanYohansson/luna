{-# LANGUAGE NoStrict #-}

module Luna.Syntax.Text.Parser.Lexer.Names where

import Prologue


---------------------------
-- === Special names === --
---------------------------

acc, app, arrow, lam, minus, typed, uminus, unify, update,
    wildcard, invalid :: IsString s => s
acc      = "."         ; {-# INLINE acc      #-}
app      = "#app#"     ; {-# INLINE app      #-}
arrow    = "->"        ; {-# INLINE arrow    #-}
lam      = ":"         ; {-# INLINE lam      #-}
minus    = "-"         ; {-# INLINE minus    #-}
typed    = "::"        ; {-# INLINE typed    #-}
uminus   = "#uminus#"  ; {-# INLINE uminus   #-}
unify    = "="         ; {-# INLINE unify    #-}
update   = "="         ; {-# INLINE update   #-} -- #update# ?
wildcard = "_"         ; {-# INLINE wildcard #-}
invalid  = "#invalid#" ; {-# INLINE invalid  #-}
