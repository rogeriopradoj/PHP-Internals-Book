.. _runing_the_test_suite:

Executando a suíte de testes
============================

Agora que temos um entendimento básico de qual tipo de teste estamos fazendo, vamos executar a suíte de testes. Antes que possamos rodar
os testes, tenha certeza que você compilou com sucesso o php a partir do fonte e que você tem um executável
em ``sapi/cli/php``.

Existem duas formas de executar a suíte de testes.

Execução dos testes diretamente com o ``run-tests.php``
-------------------------------------------------------

Você pode rodar a suíte de testes diretamente com o run-tests.php. No mínimo você precisa especificar qual o executável php que você
gostaria de usar o que você pode fazer usando a flag ``-p``. Perceba que para rodar todos os testes corretamente deve ser passado
um caminho absoluto para o executável PHP.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php -p `pwd`/sapi/cli/php

Um meio de usar um atalho que você pode usar para dizer ao run-tests que use o executável PHP que está sendo invocado no momento
é com a flag ``-P``.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php -P

Se você não quiser definir a flag `-p`` ou a ``-P`` todas as vezes, você pode especificar o executável php usando
a variável de ambiente ``TEST_PHP_EXECUTABLE`` que pode ser definida com o comando ``export`` em máquinas Linux.

.. code-block:: bash

    ~/php-src> export TEST_PHP_EXECUTABLE=sapi/cli/php
    ~/php-src> sapi/cli/php run-tests.php

No Windows, você pode definir a variável de ambiente usando ``set``.

.. code-block:: bash

    C:\php-src> set TEST_PHP_EXECUTABLE=sapi/cli/php
    C:\php-src> sapi/cli/php run-tests.php

Por padrão ``run-tests.php`` irá começar rodando todos os mais de 15.000 da suíte, o que pode demorar um tempão. Você
pode especificar uma pasta específica de testes para rodar ou mesmo um teste único. O seguinte exemplo irá executar todos os testes
associados com `PHP 7's CSPRNG`_.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php -P ext/standard/tests/random

Você também pode especificar múltiplos diretórios ou arquivos alvo para rodar.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php -P Zend/ ext/reflection/ ext/standard/tests/array/

Com sorte, todos os testes passaram. Caso contrário... oops.

.. _PHP 7's CSPRNG: http://php.net/csprng

Execução dos testes via ``Makefile`` (recomendado)
--------------------------------------------------

A forma recomendada de rodar a suíte de testes é via comando ``test`` que é definido no ``Makefile``. O
comando ``test`` faz todo o trabalho duro de especificar o executável PHP para você (aquele que você compilou), definir algumas
configurações INI padrões e especificar as melhores flags do run-tests para você. Você nem precisa se preocupar em configurar
variáveis de ambiente nem definir flags adicionais, sendo um comando bem simples.

.. code-block:: bash

    ~/php-src> make test

Como antes, ``run-tests.php`` começará a rodar a suíte de testes inteira. Para especificar uma pasta ou um teste único para ser executado você
pode passar para o ``make`` uma variável ``TESTS``. O exemplo a seguir irá testar se o PHP pode operar com binários literais adequadamente.

.. code-block:: bash

    ~/php-src> make test TESTS=Zend/tests/binary.phpt

Você pode especificar múltipos diretórios ou arquivos alvo para serem executados separando cada caminho por um espaço na variável ``TESTS``.

.. code-block:: bash

    ~/php-src> make test TESTS="Zend/ ext/reflection/ ext/standard/tests/array/"

Execução de testes em paralelo
------------------------------

Isso não é possível.

Mais opções
-----------

Para uma lista completa das opções que run-tests suporta, rode-o seguido de ``--help``.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php --help
