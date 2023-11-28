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

--10. Qual o paciente que mais fez consultas.

--12. Qual o paciente que menos fez exames.

--14. Qual o médico que menos solicita exames.

--16. Qual exame nunca foi solicitado.

--18. Fazer uma consulta com a estatística de pacientes por sexo, ou seja a quantidade de pacientes por sexo.

--20. Fazer uma consulta com a estatística de exames solicitados, ou seja a quantidade de solicitações por exames cadastrados.(lembrando que exames podem ser solicitados em consultas ou em prontuários de internação).

--22. Fazer uma consulta com a estatística de médicos por especialidade, ou seja a quantidade de médicos por especialidade.

--24. Listar os pacientes que já realizaram consultas, exames por consulta e por internação, internação e receberam medicamento em internação.

--26. Listar os médicos que menos solicitaram exames.

--28. Fazer uma consulta que liste o faturamento por mês separado por consulta, exame e internações. Formato de saída: Mês, valorTotalConsultas, ValorTotalExames, ValorTotalInternações.
