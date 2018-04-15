{-# LANGUAGE CPP #-}

module Luna.IR.Term.Ast where

import Prologue hiding (Imp, seq)

import qualified Foreign.Storable.Deriving         as Storable
import qualified Luna.IR.Component.Term.Definition as Term
import qualified Luna.IR.Term.Format               as Format
import qualified OCI.Data.Name                     as Name

import Data.Vector.Storable.Foreign      (Vector)
import Luna.IR.Component.Term.Class      (Terms)
import Luna.IR.Component.Term.Definition (LinkTo, Ln)
import OCI.Data.Name                     (Name)

-- FIXME: remove when refactoring Cmp instances
import Luna.IR.Term.Core ()

import Data.PtrList.Mutable (UnmanagedPtrList)
type LinksTo a = UnmanagedPtrList (LinkTo a)



-----------------
-- === Ast === --
-----------------

-- === Import helpers === --

data ImportSourceData
    = Relative (Vector Name)
    | Absolute (Vector Name)
    | World
    deriving (Eq, Generic, Show)
Storable.derive ''ImportSourceData

data ImportTargetData
    = Everything
    | Listed (Vector Name)
    deriving (Eq, Generic, Show)
Storable.derive ''ImportTargetData


-- === Definition === --

Term.define [d|
 data Ast
    = AccSection   { path     :: Vector Name                                   }
    | Disabled     { body     :: LinkTo Terms                                  }
    | Documented   { doc      :: Vector Char  , base   :: LinkTo  Terms        }
    | Function     { name     :: LinkTo Terms , args   :: LinksTo Terms
                   , body     :: LinkTo Terms                                  }
    | Grouped      { body     :: LinkTo Terms                                  }
    | Imp          { source   :: LinkTo Terms , target :: ImportTargetData     }
    | ImportHub    { imps     :: LinksTo Terms                                 }
    | ImportSource { body     :: ImportSourceData                              }
    | Invalid      { desc     :: Name                                          }
    | List         { items    :: LinksTo Terms                                 }
    | Marked       { marker   :: LinkTo Terms , body   :: LinkTo Terms         }
    | Marker       { id       :: Word64                                        }
    | SectionLeft  { operator :: LinkTo Terms , body   :: LinkTo Terms         }
    | SectionRight { operator :: LinkTo Terms , body   :: LinkTo Terms         }
    | Modify       { base     :: LinkTo Terms , path   :: Vector Name
                   , operator :: Name         , value  :: LinkTo Terms         }
    | Metadata     { content  :: Vector Char                                   }
    | Record       { isNative :: Bool         , name   :: Name
                   , params   :: LinksTo Terms, conss  :: LinksTo Terms
                   , decls    :: LinksTo Terms                                 }
    | RecordCons   { name     :: Name         , fields :: LinksTo Terms        }
    | RecordFields { names    :: Vector Name  , tp     :: LinkTo Terms         }
    | Seq          { former   :: LinkTo Terms , later  :: LinkTo Terms         }
    | Tuple        { items    :: LinksTo Terms                                 }
    | Typed        { base     :: LinkTo Terms , tp     :: LinkTo Terms         }
    | Unit         { imps     :: LinkTo Terms , units  :: LinksTo Terms
                   , cls      :: LinkTo Terms                                  }
    -- DEPRECATED:
    | FunctionSig  { name     :: LinkTo Terms , sig    :: LinkTo Terms         }
 |]


-- === FFI Imports === --

-- FIXME: May be able to become a `Maybe` pending discussion in the
-- following issue: https://github.com/luna/luna/issues/179
data ForeignImportType
    = Default
    | Safe
    | Unsafe
    deriving (Eq, Generic, Show)
Storable.derive ''ForeignImportType

Term.define [d|
 data Ast
    = ForeignImport       { lang    :: Name         , lst  :: LinksTo Terms }
    | ForeignImportList   { loc     :: LinkTo Terms , imps :: LinksTo Terms }
    | ForeignImportSymbol { safety  :: LinkTo Terms , name :: LinkTo  Terms
                          , locName :: Name         , tp   :: LinkTo  Terms }
    | ForeignImportSafety { safety  :: ForeignImportType                    }
 |]

-- data TermForeignImportList a = ForeignImportList
-- { __language :: !Name
-- , __imports  :: ![a]
-- } deriving (Eq, Foldable, Functor, Generic, Show)
-- makeLensedTerm ''TermForeignImportList

-- data TermForeignLocationImportList a = ForeignLocationImportList
-- { __importLocation :: !a
-- , __imports        :: ![a]
-- } deriving (Eq, Foldable, Functor, Generic, Show)
-- makeLensedTerm ''TermForeignLocationImportList

-- data TermForeignSymbolImport a = ForeignSymbolImport
-- { __safety     :: !a
-- , __importName :: !a
-- , __localName  :: !Name
-- , __type       :: !a
-- } deriving (Eq, Foldable, Functor, Generic, Show)
-- makeLensedTerm ''TermForeignSymbolImport

-- -- FIXME [Ara] May be able to become a `Maybe` pending discussion in the
-- -- following issue: https://github.com/luna/luna/issues/179
-- data ForeignImpType
-- = Default -- Unsafe if not specified.
-- | Safe
-- | Unsafe
-- deriving (Eq, Generic, Show)

-- data TermForeignImportSafety a = ForeignImportSafety
-- { __safety :: !ForeignImpType
-- } deriving (Eq, Foldable, Functor, Generic, Show)
-- makeLensedTerm ''TermForeignImportSafety