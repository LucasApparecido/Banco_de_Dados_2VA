--2. Listar os dados de todos os Médicos cadastrados.
select 
    m.crm as crm,
    m.nome as nome
from medico m;
--4. Listar os dados de todas as internações realizadas no hospital. ( pelo menos o nome do paciente, nome do médico que solicitou a internação, data da entrada e da saída, quarto que o paciente ficou internado)
select 
    p.nome as nome_paciente,
    m.nome as nome_medico,
    i.data_internacao as data_internacao,
    i.data_alta as data_alta,
    q.numero as quarto_numero
from internacao i, paciente p, medico m, quarto q
where p.cpf = i.paciente_cpf and m.crm = i.medico_crm and q.numero = i.quarto_numero;
--6. Listar todas as internações e os histórico das internações(apenas os medicamentos ministrados).(Dados da Internação conforme questão 4, e os medicamentos ministrados com a data e hora)
select 
    p.nome as nome_paciente,
    m.nome as nome_medico,
    i.data_internacao as data_internacao,
    i.data_alta as data_alta,
    q.numero as quarto_numero,
    med.nome as nome_medicamento,
    im.data_aplicacao as data_aplicacao
from internacao i, paciente p, medico m, quarto q, internacao_medic im, medicamento med
where p.cpf = i.paciente_cpf and m.crm = i.medico_crm and q.numero = i.quarto_numero and med.id = im.medicamento_id;
--8. Fazer uma consulta com a estatística de atendimento em consultas realizado pelos médicos com detalhamento por convênio, ou seja listar a quantidade de atendimento realizados pelo médico por convênio.
select
    m.nome as medico_nome,
    c.convenio_id as convenio_id,
    count(*) as qtd_atendimentos
from consulta c, medico m
where c.medico_crm = m.crm
group by m.nome, c.convenio_id
order by m.nome, c.convenio_id;
--10. Qual o paciente que mais fez consultas.
select
    p.nome as paciente_nome,
    p.cpf as paciente_cpf,
    count(*) as quantidade_consultas
from
    consulta c, paciente p
where
    c.paciente_cpf = p.cpf
group by
    p.cpf
order by
    quantidade_consultas desc
limit 1;
--12. Qual o paciente que menos fez exames.
select
    m.nome as medico_nome,
    c.convenio_id as convenio_id,
    count(*) as qtd_atendimentos
from consulta c, medico m
where c.medico_crm = m.crm
group by m.nome, c.convenio_id
order by m.nome, c.convenio_id;
--10. Qual o paciente que mais fez consultas.
select
    p.nome as paciente_nome,
    p.cpf as paciente_cpf,
    count(*) as quantidade_consultas
from
    consulta c, paciente p
where
    c.paciente_cpf = p.cpf
group by
    p.cpf
order by
    quantidade_consultas asc
limit 1;
--14. Qual o médico que menos solicita exames.
select
    m.nome as medico_nome,
    count(ce.exame_id) as quantidade_exames
from medico m, consulta_exa ce
where ce.medico_crm = m.crm
group by m.nome
order by quantidade_exames asc;

--16. Qual exame nunca foi solicitado.
select
    e.nome as nome_exame
from
    exame e
where
not exists (
    select 1
    from consulta_exa ce
    where e.id = ce.exame_id
);

--18. Fazer uma consulta com a estatística de pacientes por sexo, ou seja a quantidade de pacientes por sexo.
select
	count(p.cpf) as quantidade,
	p.sexo as sexo
from paciente p
group by p.sexo;
--20. Fazer uma consulta com a estatística de exames solicitados, ou seja a quantidade de solicitações por exames cadastrados.(lembrando que exames podem ser solicitados em consultas ou em prontuários de internação).
select
	count(*) as quantidade_exames,
	e.nome as nome_exame
from consulta_exa ce, internacao_exa ie, exame e
where e.id = ce.exame_id or e.id = ie.exame_id
group by e.nome;
--22. Fazer uma consulta com a estatística de médicos por especialidade, ou seja a quantidade de médicos por especialidade.
select
	count(m.crm) as quantidade,
	e.nome as especialidade_nome
from medico m, especialidade e, medico_esp me
where m.crm = me.medico_crm and me.especialidade_id = e.id
group by e.id;
--24. Listar os pacientes que já realizaram consultas, exames por consulta e por internação, internação e receberam medicamento em internação.
select distinct
    p.nome as nome_paciente,
    p.data_nascimento as data_nascimento,
    p.cpf as cpf_paciente
from
    paciente p,
    consulta c,
    consulta_exa ce,
    internacao_exa ie,
    internacao_medic im,
    internacao i
where
    (p.cpf = c.paciente_cpf or p.cpf = ce.paciente_cpf or i.id = ie.internacao_id or i.id = im.internacao_id or p.cpf = i.paciente_cpf)
    and (c.data_consulta is not null or ce.data_consulta is not null or ie.internacao_id is not null or im.internacao_id is not null);
--26. Listar os médicos que menos solicitaram exames.
select
	m.nome as medico_nome,
	count(*) as quantidade_solicitacoes
from medico m, internacao_exa ie, consulta_exa ce, internacao i
where (m.crm = i.medico_crm and ie.internacao_id = i.id) or ce.medico_crm = m.crm
group by m.nome
order by quantidade_solicitacoes desc;
--28. Fazer uma consulta que liste o faturamento por mês separado por consulta, exame e internações. Formato de saída: Mês, valorTotalConsultas, ValorTotalExames, ValorTotalInternações.
