-- Quantos veículos únicos (mesma marca e modelo) temos na base por produto?

SELECT DISTINCT
    nomesku
    , codigo
    , marca
    , modelo
    , count(1) as qtd_veiculos
FROM `karhub-data-engineer-test`.`cadastro_produto`.`kh_data_engineer_teste_pedroNobrega`
GROUP BY
    nomesku
    , codigo
    , marca
    , modelo
ORDER BY
    qtd_veiculos DESC