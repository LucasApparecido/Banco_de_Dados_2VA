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

--2. Listar os dados de todos os Médicos cadastrados.
select
    m.crm as crm,
    m.nome as nome
from
    medico m;

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

--4. Listar os dados de todas as internações realizadas no hospital. ( pelo menos o nome do paciente, nome do médico que solicitou a internação, data da entrada e da saída, quarto que o paciente ficou internado)
select
    p.nome as nome_paciente,
    m.nome as nome_medico,
    i.data_internacao as data_internacao,
    i.data_alta as data_alta,
    q.numero as quarto_numero
from
    internacao i,
    paciente p,
    medico m,
    quarto q
where
    p.cpf = i.paciente_cpf
    and m.crm = i.medico_crm
    and q.numero = i.quarto_numero;

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
    exame e
where
    p.cpf = i.paciente_cpf
    and m.crm = i.medico_crm
    and q.numero = i.quarto_numero
    and ie.internacao_id = i.id
    and e.id = ie.exame_id;

--6. Listar todas as internações e os histórico das internações(apenas os medicamentos ministrados).(Dados da Internação conforme questão 4, e os medicamentos ministrados com a data e hora)
select
    p.nome as nome_paciente,
    m.nome as nome_medico,
    i.data_internacao as data_internacao,
    i.data_alta as data_alta,
    q.numero as quarto_numero,
    med.nome as nome_medicamento,
    im.data_aplicacao as data_aplicacao
from
    internacao i,
    paciente p,
    medico m,
    quarto q,
    internacao_medic im,
    medicamento med
where
    p.cpf = i.paciente_cpf
    and m.crm = i.medico_crm
    and q.numero = i.quarto_numero
    and med.id = im.medicamento_id;

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

--8. Fazer uma consulta com a estatística de atendimento em consultas realizado pelos médicos com detalhamento por convênio, ou seja listar a quantidade de atendimento realizados pelo médico por convênio.
select
    m.nome as medico_nome,
    c.convenio_id as convenio_id,
    count(*) as qtd_atendimentos
from
    consulta c,
    medico m
where
    c.medico_crm = m.crm
group by
    m.nome,
    c.convenio_id
order by
    m.nome,
    c.convenio_id;

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

--10. Qual o paciente que mais fez consultas.
select
    p.nome as paciente_nome,
    p.cpf as paciente_cpf,
    count(*) as quantidade_consultas
from
    consulta c,
    paciente p
where
    c.paciente_cpf = p.cpf
group by
    p.cpf
order by
    quantidade_consultas desc
limit
    1;

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

--12. Qual o paciente que menos fez exames.
select
    m.nome as medico_nome,
    c.convenio_id as convenio_id,
    count(*) as qtd_atendimentos
from
    consulta c,
    medico m
where
    c.medico_crm = m.crm
group by
    m.nome,
    c.convenio_id
order by
    m.nome,
    c.convenio_id;

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

--14. Qual o médico que menos solicita exames.
select
    m.nome as medico_nome,
    count(ce.exame_id) as quantidade_exames
from
    medico m,
    consulta_exa ce
where
    ce.medico_crm = m.crm
group by
    m.nome
order by
    quantidade_exames asc;

--15. Qual o médico que mais solicita exames.
select
    m.nome as nome_medico,
    count(ce.id) + count(ie.id) as quantidade_exames
from
    medico m
    left join consulta_exa ce on m.crm = ce.medico_crm
    left join internacao i on m.crm = i.medico_crm
    left join internacao_exa ie on i.id = ie.internacao_id
group by
    m.nome
order by
    quantidade_exames desc
limit
    1;

--16. Qual exame nunca foi solicitado.
select
    e.nome as nome_exame
from
    exame e
where
    not exists (
        select
            1
        from
            consulta_exa ce
        where
            e.id = ce.exame_id
    );

--17. Qual o exame mais solicitado.
select
    e.nome as nome_exame,
    count(ce.exame_id) + count(ie.exame_id) as quantidade_exames
from
    consulta_exa ce
    left join exame e on ce.exame_id = e.id
    left join internacao_exa ie on ie.exame_id = e.id
group by
    e.nome
order by
    quantidade_exames desc
limit
    1;

--18. Fazer uma consulta com a estatística de pacientes por sexo, ou seja a quantidade de pacientes por sexo.
select
    count(p.cpf) as quantidade,
    p.sexo as sexo
from
    paciente p
group by
    p.sexo;

--19. Fazer uma consulta com a estatística de pacientes por cidade.
select
    e.cidade,
    count(p.cpf) as quantidade_pacientes
from
    paciente p
    join endereco e on p.cpf = e.paciente_cpf
group by
    e.cidade;

--20. Fazer uma consulta com a estatística de exames solicitados, ou seja a quantidade de solicitações por exames cadastrados.(lembrando que exames podem ser solicitados em consultas ou em prontuários de internação).
select
    exame.nome as nome_exame,
    coalesce(count(consulta_exa.id), 0) + coalesce(count(internacao_exa.id), 0) as quantidade_solicitacoes
from
    exame
    left join consulta_exa on exame.id = consulta_exa.exame_id
    left join internacao_exa on exame.id = internacao_exa.exame_id
group by
    exame.nome;

--21. Listar os médicos da especialidade que teve maior número de consulta 
select
    m.nome as nome_medico,
    e.nome as nome_especialidade,
    count(c.medico_crm) as quantidade_consultas
from
    consulta c
    join medico m on c.medico_crm = m.crm
    join medico_esp me on m.crm = me.medico_crm
    join especialidade e on me.especialidade_id = e.id
group by
    m.nome,
    e.nome
order by
    quantidade_consultas DESC;

--22. Fazer uma consulta com a estatística de médicos por especialidade, ou seja a quantidade de médicos por especialidade.
select
    count(m.crm) as quantidade,
    e.nome as especialidade_nome
from
    medico m,
    especialidade e,
    medico_esp me
where
    m.crm = me.medico_crm
    and me.especialidade_id = e.id
group by
    e.id;

--23. Fazer uma consulta com a estatística de quantos exames, internações e consultas realizadas por médico, ou seja listar: médico, totalexames, totalinternacoes, totalconsultas.
select
    m.nome as nome_medico,
    count(ce.exame_id) + count(ie.exame_id) as total_exames,
    count(i.id) as total_internacoes,
    count(c.medico_crm) as total_consultas
from
    medico m
    left join consulta_exa ce on m.crm = ce.medico_crm
    left join internacao i on m.crm = i.medico_crm
    left join internacao_exa ie on i.id = ie.internacao_id
    left join consulta c on m.crm = c.medico_crm
group by
    m.nome;

--24. Listar os pacientes que já realizaram consultas, exames por consulta e por internação, internação e receberam medicamento em internação.
select
    distinct p.nome as nome_paciente,
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
    (
        p.cpf = c.paciente_cpf
        or p.cpf = ce.paciente_cpf
        or i.id = ie.internacao_id
        or i.id = im.internacao_id
        or p.cpf = i.paciente_cpf
    )
    and (
        c.data_consulta is not null
        or ce.data_consulta is not null
        or ie.internacao_id is not null
        or im.internacao_id is not null
    );

--25. Listar os médicos que já realizaram consultas, solicitaram exames em consultas, e nunca solicitaram exames em internação
select
    m.nome as nome_medico
from
    medico m
    left join consulta c on m.crm = c.medico_crm
    left join consulta_exa ce on m.crm = ce.medico_crm
    left join internacao i on m.crm = i.medico_crm
    left join internacao_exa ie on i.id = ie.internacao_id
where
    c.medico_crm is not null
    and ce.medico_crm is not null
    and ie.internacao_id is null;

--26. Listar os médicos que menos solicitaram exames.
with exames_por_medico as (
    select
        m.nome as nome_medico,
        count(ce.medico_crm) + count(ie.internacao_id) as quantidade_exames
    from
        medico m
    left join consulta_exa ce on m.crm = ce.medico_crm
    left join internacao i on m.crm = i.medico_crm
    left join internacao_exa ie on i.id = ie.internacao_id
    group by
        m.nome
)

select
    nome_medico,
    SUM(quantidade_exames) as total_exames
from
    DoctorExams
group by
    nome_medico
order by
    total_exames asc;

--27. Faça vocês do grupo uma pergunta que necessite utilizar funções agregadas e subconsulta para obter a resposta.
--Qual é a média de consultas que geraram internações no hospital?
select
    round(avg(total_consultas), 2) as media_consultas
from
    (
        select
            paciente_cpf,
            count(*) as total_consultas
        from
            consulta
        where
            paciente_cpf in (
                select
                    distinct paciente_cpf
                from
                    internacao
            )
        group by
            paciente_cpf
    ) as consultas_por_paciente;

--28. Fazer uma consulta que liste o faturamento por mês separado por consulta, exame e internações. Formato de saída: Mês, valorTotalConsultas, ValorTotalExames, ValorTotalInternações.
select
    extract(
        month
        from
            c.data_consulta
    ) as mes,
    sum(c.valor) as valor_total_consultas,
    sum(ce.valor) + sum(ie.valor) as valor_total_exames,
    sum(i.valor) as valor_total_internacoes
from
    consulta c
    left join consulta_exa ce on c.data_consulta = ce.data_consulta
    left join internacao i on c.data_consulta = i.data_consulta
    left join internacao_exa ie on i.id = ie.internacao_id
group by
    extract(
        month
        from
            c.data_consulta
    );