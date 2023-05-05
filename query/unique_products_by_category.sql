-- Quantos produtos únicos temos na base por categoria ?

SELECT DISTINCT
    nomesku
    , codigo
    , categoria
    , count(1) as qtd_produtos
FROM `karhub-data-engineer-test`.`cadastro_produto`.`kh_data_engineer_teste_pedroNobrega`
GROUP BY
    nomesku
    , codigo
    , categoria
ORDER BY
    qtd_produtos DESC
