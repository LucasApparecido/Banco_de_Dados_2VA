--1. Listar os dados de todos os Pacientes cadastrados.
select
    p.cpf,
    p.nome,
    p.data_nascimento,
    c.nome as convenio,
    e.rua,
    e.cidade,
    e.numero,
    e.cep
from
    paciente p,
    endereco e,
    convenio c
where
    p.cpf = e.paciente_cpf
    and p.convenio_id = c.id;

--3. Listar os dados de todas as consultas realizadas no hospital.(pelo menos o nome do Paciente, Médico, data da consulta e convênio)
select
    p.nome as nome_paciente,
    m.nome as nome_medico,
    c.data_consulta,
    co.nome as convenio
from
    consulta c,
    paciente p,
    medico m,
    convenio co
where
    c.paciente_cpf = p.cpf
    and c.medico_crm = m.crm
    and p.convenio_id = co.id;

--5. Listar todas as internações e os histórico das internações(apenas os exames).(Dados da Internação conforme questão 4, e os exames solicitados caso existam e seu resultado caso existam
select
    p.nome as nome_paciente,
    m.nome as nome_medico,
    i.data_internacao as data_internacao,
    i.data_alta as data_alta,
    q.numero as quarto_numero,
    e.nome as nome_exame,
    ie.data_agenda as data_agenda,
    ie.data_realizacao as data_realizacao,
    ie.resultado as resultado
from
    internacao i,
    paciente p,
    medico m,
    quarto q,
    internacao_exa ie,
    exame e,
where
    p.cpf = i.paciente_cpf
    and m.crm = i.medico_crm
    and q.numero = i.quarto_numero
    and ie.internacao_id = i.id
    and e.id = ie.exame_id;

--7. Fazer uma consulta com a estatística de atendimento em consulta realizado pelos médicos. Ou seja a quantidade de pacientes atendido pelos médicos em um intervalo de data .(o intervalo será definido conforme a sua massa de dados).
select
    m.nome as nome_medico,
    count(c.paciente_cpf) as quantidade_pacientes
from
    consulta c
    join medico m on c.medico_crm = m.crm
where
    c.data_consulta between '2023-01-01'
    and '2023-12-31'
group by
    m.nome;

--9. Listar os Paciente que nunca fizeram exames.
select
    p.*
from
    paciente p
    left join consulta_exa ce on p.cpf = ce.paciente_cpf
    left join internacao i on p.cpf = i.paciente_cpf
    left join internacao_exa ie on i.id = ie.internacao_id
where
    ce.paciente_cpf is null
    and ie.internacao_id is null;

--11. Qual o paciente que mais fez exames
select
    p.*,
    count(ce.id) + count(ie.id) as total_exames
from
    paciente p
    left join consulta_exa ce on p.cpf = ce.paciente_cpf
    left join internacao i on p.cpf = i.paciente_cpf
    left join internacao_exa ie on i.id = ie.internacao_id
group by
    p.cpf
order by
    total_exames desc
limit
    1;

--13. Qual o médico mais produtivo(que mais atendeu consultas).
select 
    m.nome as nome_medico,
    count(c.medico_crm) as quantidade_consultas
from
    consulta c
    join medico m on c.medico_crm = m.crm
group by
    m.nome
order by
    quantidade_consultas desc
limit
    1;

--15. Qual o médico que mais solicita exames.
--17. Qual o exame mais solicitado.
--19. Fazer uma consulta com a estatística de pacientes por cidade.
--21. Listar os médicos da especialidade que teve maior número de consulta
--23. Fazer uma consulta com a estatística de quantos exames, internações e consultas realizadas por médico, ou seja listar: médico, totalexames, totalinternacoes, totalconsultas.
--25. Listar os médicos que já realizaram consultas, solicitaram exames em consultas, e nunca solicitaram exames em internação
--27. Faça vocês do grupo uma pergunta que necessite utilizar funções agregadas e subconsulta para obter a resposta.