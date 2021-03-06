{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

import           GHC.Generics (Generic)
import           Servant.API  ((:<|>), (:>), Capture, Get, JSON, Post, ReqBody)
import           Servant.Elm  (ElmOptions (..), ElmType, Proxy (Proxy),
                               Spec (Spec), defElmImports, defElmOptions,
                               generateElmForAPIWith, specsToDir)

data Book = Book
  { name :: String
  } deriving (Show, Eq, Generic)

instance ElmType Book

type BooksApi = "books" :> ReqBody '[JSON] Book :> Post '[JSON] Book
           :<|> "books" :> Get '[JSON] [Book]
           :<|> "books" :> Capture "bookId" Int :> Get '[JSON] Book

myElmOpts :: ElmOptions
myElmOpts = defElmOptions { urlPrefix = "http://localhost:8000" }

spec :: Spec
spec = Spec ["Generated", "BooksApi"]
            (defElmImports
             : generateElmForAPIWith myElmOpts (Proxy :: Proxy BooksApi))

main :: IO ()
main = specsToDir [spec] "elm"
