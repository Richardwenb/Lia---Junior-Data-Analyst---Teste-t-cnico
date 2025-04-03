select dp.nome, count(e.nome) as qtd_funcionario, avg(vc.valor) as media_salarial
from empregado e
inner join departamento dp on dp.cod_dep = e.lotacao 
inner join vencimento vc on vc.cod_venc = e.lotacao 
group by dp.nome
order by 3 DESC
