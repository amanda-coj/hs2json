# Projeto hs2json

Projeto em Haskell para representar valores JSON e serializá-los em formato legível (*pretty-printed*) ou compacto, sem depender de uma biblioteca externa de JSON para a lógica principal.

## Funcionalidades

- Representação dos valores JSON por meio do tipo algébrico `JValue`.
- Acesso seguro aos valores com funções que retornam `Maybe`, como `getString`, `getInt`, `getDouble`, `getBool`, `getObject` e `getArray`.
- Renderização de JSON formatado com `renderJSON`.
- Renderização de JSON compacto com `renderJSONCompact`.
- Escape de aspas, barras invertidas, quebras de linha, tabulações e caracteres de controle em strings JSON.
- Módulo `Prettify` com combinadores para construir e renderizar documentos.

## Tecnologias

- Haskell
- GHC 9.10.3 (ambiente utilizado nos testes)
- Cabal
- QuickCheck (para testes baseados em propriedades)

## Estrutura do projeto

```text
hs2json/
├── app/
│   └── Main.hs          # Ponto de entrada do executável de demonstração
├── src/
│   ├── SimpleJSON.hs    # Tipo JValue e funções de acesso
│   ├── Prettify.hs      # Estrutura Doc e combinadores de formatação
│   └── PrettyJSON.hs    # Serialização formatada e compacta
├── test/                # Suíte de testes
├── hs2json.cabal        # Configuração do pacote Cabal
├── CHANGELOG.md
├── LICENSE
└── README.md
```

## Pré-requisitos

Instale o [GHCup](https://www.haskell.org/ghcup/) e utilize uma versão do GHC compatível com as dependências definidas em `hs2json.cabal`. O projeto foi compilado e testado no ambiente GHC 9.10.3.

Para conferir as ferramentas instaladas:

```powershell
ghc --version
cabal --version
```

## Compilar

Na pasta que contém `hs2json.cabal`, execute:

```powershell
cabal build
```

Se o diretório de compilação dentro de uma pasta sincronizada pelo OneDrive apresentar erros de permissão, experimente usar um diretório de build separado:

```powershell
cabal build --builddir="C:\cabal-build\hs2json"
```

## Executar

Para executar o programa de demonstração:

```powershell
cabal run hs2json
```

O executável apresenta exemplos de JSON formatado, JSON compacto e uso das funções de acesso definidas em `SimpleJSON`.

## Executar os testes

```powershell
cabal test
```

Em ambientes nos quais o diretório `dist-newstyle` esteja bloqueado, use um diretório de build separado:

```powershell
cabal test --builddir="C:\cabal-build\hs2json"
```

### Resultado validado

No ambiente GHC 9.10.3, `cabal build` foi concluído com sucesso e `cabal test` terminou com `PASS`. Seis verificações baseadas em QuickCheck informaram `+++ OK, passed 100 tests.` cada uma. O Cabal reportou `1 of 1 test suites (1 of 1 test cases) passed`; os testes de propriedade são executados dentro dessa suíte.

## Exemplo de uso

O tipo `JValue` representa os principais tipos JSON:

```haskell
import PrettyJSON
import SimpleJSON

exemplo :: JValue
exemplo = JObject
  [ ("nome", JString "hs2json")
  , ("versao", JNumber 1)
  , ("ativo", JBool True)
  , ("dados", JArray [JString "Haskell", JNull])
  ]

jsonFormatado :: String
jsonFormatado = renderJSON exemplo

jsonCompacto :: String
jsonCompacto = renderJSONCompact exemplo
```

As funções de acesso retornam `Maybe`, indicando se o valor tem o tipo solicitado:

```haskell
getString (JString "exemplo") -- Just "exemplo"
getInt (JNumber 42)            -- Just 42
getBool (JBool True)           -- Just True
isNull JNull                   -- True
```

## Dificuldades encontradas durante o desenvolvimento

- **Inicialização do GHCi no Windows:** ocorreu o erro `addDLL: ucrt or dependencies not loaded (Win32 error 126)`. Foi necessário reinstalar o ambiente Haskell para conseguir executar o GHCi.
- **Arquivos de compilação e OneDrive:** o Cabal encontrou `permission denied` ao tentar remover arquivos em `dist-newstyle`. Direcionar a compilação para `C:\cabal-build\hs2json` permitiu compilar a biblioteca e as dependências fora da pasta sincronizada. Em uma execução posterior, `cabal test` também concluiu com sucesso usando o diretório padrão.
- **Arquivos gerados no Git:** o primeiro commit incluiu arquivos gerados dentro de `dist-newstyle`. Essa pasta deve ser ignorada pelo Git; mantenha uma regra como `**/dist-newstyle/` no `.gitignore`.
- **Autenticação do GitHub:** o primeiro `git push` foi recusado porque as credenciais HTTPS não foram aceitas. A autenticação precisa estar configurada para enviar commits ao repositório remoto.

## Licença

Consulte o arquivo [LICENSE](LICENSE) para os termos de uso e distribuição.
