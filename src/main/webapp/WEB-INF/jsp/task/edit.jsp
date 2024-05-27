<%@page contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="u" tagdir="/WEB-INF/tags"%>
<%--@elvariable id="task" type="by.vsu.twoa.domain.Task"--%>
<c:choose>
	<c:when test="${not empty task}">
		<c:set var="title" value="Редактирование задачи ${task.name}"/>
	</c:when>
	<c:otherwise>
		<c:set var="title" value="Добавление новой задачи"/>
	</c:otherwise>
</c:choose>
<u:page title="${title}">
	<c:if test="${not empty param['error']}">
		<div class="w3-panel w3-pale-red w3-leftbar w3-border-red">
			<span onclick="this.parentElement.style.display='none'" class="w3-button w3-right w3-hover-red">&times;</span>
			<h3>Ошибка</h3>
			<p>${param['error']}</p>
		</div>
	</c:if>
	<c:if test="${not empty param['info']}">
		<div class="w3-panel w3-pale-green w3-leftbar w3-border-green">
			<span onclick="this.parentElement.style.display='none'" class="w3-button w3-right w3-hover-green">&times;</span>
			<h3>Информация</h3>
			<p>${param['info']}</p>
		</div>
	</c:if>
	<c:url var="url_task_save_html" value="/task/save.html"/>
	<form action="${url_task_save_html}" method="post" class="w3-container form">
		<c:if test="${not empty task}">
			<input type="hidden" name="id" value="${task.id}"/>
		</c:if>
		<div class="form-element">
			<label for="name">Название*:</label>
			<input type="text" name="name" value="${task.name}" id="name" class="w3-input w3-border">
		</div>
		<c:if test="${not empty task}">
			<div class="form-element">
				<fmt:formatDate var="task_created" value="${task.created}" pattern="dd.MM.yyyy"/>
				<label for="created">Дата создания:</label>
				<input type="text" value="${task_created}" id="created" class="w3-input w3-border" disabled>
			</div>
		</c:if>
		<h3>Исходные данные для задачи</h3>
		<div class="form-element">
			<table>
				<tr>
					<th colspan="8">Треугольник</th>
				</tr>
				<tr>
					<th colspan="2">Точка №1</th>
					<th class="line"></th>
					<th colspan="2">Точка №2</th>
					<th class="line"></th>
					<th colspan="2">Точка №3</th>
				</tr>
				<tr>
					<td><label for="x1"><span class="math"><i>x</i><sub>1</sub></span>:</label></td>
					<td><input type="text" name="x1" value="${task.triangle.vertex1.x}" id="x1" class="w3-input w3-border"></td>
					<td class="line"></td>
					<td><label for="x2"><span class="math"><i>x</i><sub>2</sub></span>:</label></td>
					<td><input type="text" name="x2" value="${task.triangle.vertex2.x}" id="x2" class="w3-input w3-border"></td>
					<td class="line"></td>
					<td><label for="x3"><span class="math"><i>x</i><sub>3</sub></span>:</label></td>
					<td><input type="text" name="x3" value="${task.triangle.vertex3.x}" id="x3" class="w3-input w3-border"></td>
				</tr>
				<tr>
					<td><label for="y1"><span class="math"><i>y</i><sub>1</sub></span>:</label></td>
					<td><input type="text" name="y1" value="${task.triangle.vertex1.y}" id="y1" class="w3-input w3-border"></td>
					<td class="line"></td>
					<td><label for="y2"><span class="math"><i>y</i><sub>2</sub></span>:</label></td>
					<td><input type="text" name="y2" value="${task.triangle.vertex2.y}" id="y2" class="w3-input w3-border"></td>
					<td class="line"></td>
					<td><label for="y3"><span class="math"><i>y</i><sub>3</sub></span>:</label></td>
					<td><input type="text" name="y3" value="${task.triangle.vertex3.y}" id="y3" class="w3-input w3-border"></td>
				</tr>
				<tr>
					<th colspan="5">Окружность</th>
					<td colspan="3" rowspan="4"></td>
				</tr>
				<tr>
					<th colspan="2">Центр</th>
					<th class="line"></th>
					<th colspan="2">Радиус</th>
				</tr>
				<tr>
					<td><label for="x0"><span class="math"><i>x</i><sub>0</sub></span>:</label></td>
					<td><input type="text" value="${task.circle.center.x}" id="x0" class="w3-input w3-border" disabled></td>
					<td class="line"></td>
					<td><label for="r"><span class="math"><i>R</i></span>:</label></td>
					<td><input type="text" name="r" value="${task.circle.radius}" id="r" class="w3-input w3-border"></td>
				</tr>
				<tr>
					<td><label for="y0"><span class="math"><i>y</i><sub>0</sub></span>:</label></td>
					<td><input type="text" value="${task.circle.center.y}" id="y0" class="w3-input w3-border" disabled></td>
					<td class="line"></td>
					<td colspan="2"></td>
				</tr>
			</table>
		</div>
		<button type="submit" class="w3-button w3-green w3-hover-teal">Сохранить</button>
		<c:url var="url_task_list_html" value="/task/list.html"/>
		<a href="${url_task_list_html}" class="w3-button w3-blue w3-hover-indigo">Вернуться</a>
		<button type="button" class="w3-button w3-red w3-hover-pink">Удалить</button>
	</form>
	<c:if test="${not empty task and not empty task.area}">
		<h3>Решение задачи</h3>
		<p>Площадь фигуры, образованной пересечением треугольника и окружности <span class="math"><i>S</i>&nbsp;=&nbsp;<span id="area">${task.area}</span></span>.</p>
	</c:if>
	<c:url var="url_coords_duplicator_js" value="/coords-duplicator.js"/>
	<script type="text/javascript" src="${url_coords_duplicator_js}"></script>
</u:page>