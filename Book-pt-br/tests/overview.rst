.. _overview:

Visão geral dos testes
======================

O PHP tem uma suíte de testes extensa com mais de 15.000 arquivos de testes únicos. Os arquivos de teste são executados com a ferramenta de teste caixa-preta
do PHP chamada `run-tests.php`_ que pode ser encontrada no diretório raiz do código fonte do php.

"Mas espere!" você diz, "Eu ouvi dizer que o fonte do PHP não tem nenhum teste unitário". Você está certo. O código fonte do PHP tem
zero testes unitários. Mas ele tem `testes funcionais`_ e para nossa sorte, esses testes funcionais em particular são escritos em
PHP. Os arquivos de teste tem uma extensão ``.phpt`` e podem ser executados como qualquer outro arquivo PHP normalmente.

A documentação oficial sobre a escrita de testes phpt fica em `qa.php.net`_.

.. _run-tests.php: https://github.com/php/php-src/blob/master/run-tests.php
.. _`testes funcionais`: https://en.wikipedia.org/wiki/Functional_testing
.. _`qa.php.net`: http://qa.php.net/write-test.php

Testes caixa-preta
------------------

Em poucas palavras, `um teste caixa-preta` envia uma entrada para alguma função e examina a saída depois que a função tiver terminado
a execução. Se a saída corresponder com o que estávamos esperando, então o teste passou. O teste caixa-preta não se importa com *como*
algo é feito, ele apenas se importa com o resultado final. É exatamente assim que o ``run-tests.php`` funciona; ele recebe um conjunto de
entradas, executa algum código PHP e então examina a saída. Se a saída corresponder com o que era esperado, então o teste passa.

.. _black-box testing: https://en.wikipedia.org/wiki/Black-box_testing

Onde ficam os arquivos de teste
-------------------------------

Os arquivos de testes ficam em vários lugares diferentes dentro da base de código, em pastas chamadas ``tests``. Cada pasta de teste
contém arquivos ``.phpt`` pertinentes com o código contido na pasta.

* ``ext/{extension-name}/tests/`` Testes de uma extensão
* ``sapi/{sapi-name}/tests/`` Testes da SAPI
* ``Zend/tests/`` Testes da Zend engine
* ``tests/`` Mais testes da Zend engine
