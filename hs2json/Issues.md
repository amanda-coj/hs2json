# Dificuldades Encontradas — hs2json


1. Falha ao iniciar o GHCi por dependências DLL (UCRT/MinGW)

Problema: Ao executar ghci com o GHC 9.10.3 instalado pelo GHCup, o Windows apresentou o erro addDLL: ucrt or dependencies not loaded (Win32 error 126). Os comandos ghc --version, ghc --print-libdir e ghc --info funcionavam, indicando que o executável do compilador era encontrado, mas o interpretador não conseguia carregar uma dependência. O PATH também continha C:\MinGW\bin além de C:\ghcup\bin.

Analise incial: Foi removido temporariamente C:\MinGW\bin do PATH da sessão atual. A mensagem mudou para addDLL: mingw32 or dependencies not loaded (Win32 error 126), mas o GHCi continuou sem iniciar.

Solução: Foi necessário reinstalar o ambiente/ferramentas Haskell para conseguir executar o GHCi. A alteração temporária do PATH, por si só, não resolveu o problema. O histórico não especifica qual componente foi reinstalado, então o relatório registra a reinstalação do ambiente sem atribuí-la a um pacote específico.

2. Erro de permissão ao compilar dentro do OneDrive

Problema: Ao executar cabal test, o Cabal falhou ao tentar remover o diretório dist-newstyle/.../package.conf.inplace, retornando permission denied (Acesso negado.). O projeto estava dentro da pasta do OneDrive, onde arquivos podem permanecer bloqueados por processos ou pela sincronização.

Analise inicial: Os processos relacionados ao GHC, GHCi, Cabal e Haskell Language Server foram encerrados. Em seguida, os arquivos de compilação foram redirecionados para fora do OneDrive:
New-Item -ItemType Directory -Force "C:\cabal-build" | Out-Null
cabal test --builddir="C:\cabal-build\hs2json"

Solução: A execução deixou de falhar na remoção de package.conf.inplace e avançou para a compilação da suíte de testes. Portanto, o uso de um diretório de build externo contornou o bloqueio observado.
