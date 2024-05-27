package by.vsu.twoa.service;

import by.vsu.twoa.dao.DaoException;
import by.vsu.twoa.dao.TaskDao;
import by.vsu.twoa.dao.UserDao;
import by.vsu.twoa.domain.Task;
import by.vsu.twoa.domain.User;
import by.vsu.twoa.geometry.*;
import by.vsu.twoa.service.exception.ServiceException;
import by.vsu.twoa.service.exception.TaskNotExistsException;
import by.vsu.twoa.service.exception.UserNotExistsException;

import java.util.Date;
import java.util.List;

public class TaskService {
	private TaskDao taskDao;
	private UserDao userDao;

	public void setTaskDao(TaskDao taskDao) {
		this.taskDao = taskDao;
	}

	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}

	public List<Task> findByOwner(Integer id) throws ServiceException {
		try {
			User owner = userDao.read(id).orElseThrow(() -> new UserNotExistsException(id));
			List<Task> tasks = taskDao.readByOwner(id);
			tasks.forEach(task -> task.setOwner(owner));
			return tasks;
		} catch(DaoException e) {
			throw new ServiceException(e);
		}
	}

	public Task findById(Integer id) throws ServiceException {
		try {
			Task task = taskDao.read(id).orElseThrow(() -> new TaskNotExistsException(id));
			task.setOwner(userDao.read(task.getOwner().getId()).orElseThrow(() -> new UserNotExistsException(id)));
			Triangle triangle = task.getTriangle();
			Circle circle = task.getCircle();
			Vector side12 = new Vector(triangle.getVertex1(), triangle.getVertex2());
			Vector side13 = new Vector(triangle.getVertex1(), triangle.getVertex3());
			Vector side23 = new Vector(triangle.getVertex2(), triangle.getVertex3());
			double a = side12.length();
			double b = side13.length();
			boolean isVertex2Inside = a < circle.getRadius();
			boolean isVertex3Inside = b < circle.getRadius();
			double area = 0;
			if(isVertex2Inside && isVertex3Inside) {
				area += areaTriangle(a, b, side23.length());
			} else {
				Line line23 = new Line(triangle.getVertex2(), triangle.getVertex3());
				List<Point> points = circle.intersect(line23);
				if(isVertex2Inside || isVertex3Inside) {
					Point p = points.get(0);
					if(!equal(sum(new Vector(triangle.getVertex2(), p), new Vector(p, triangle.getVertex3())), new Vector(triangle.getVertex2(), triangle.getVertex3()))) {
						p = points.get(1);
					}
					if(isVertex2Inside) {
						area += areaTriangle(a, circle.getRadius(), new Vector(triangle.getVertex2(), p).length());
						area += areaSegment(circle.getRadius(), Vector.angle(side13, new Vector(triangle.getVertex1(), p)).orElse(0.0));
					}
					if(isVertex3Inside) {
						area += areaTriangle(b, circle.getRadius(), new Vector(triangle.getVertex3(), p).length());
						area += areaSegment(circle.getRadius(), Vector.angle(side12, new Vector(triangle.getVertex1(), p)).orElse(0.0));
					}
				} else {
					if(points.size() == 2) {
						Vector r1 = new Vector(triangle.getVertex1(), points.get(0));
						Vector r2 = new Vector(triangle.getVertex1(), points.get(1));
						area += areaSegment(circle.getRadius(), Vector.angle(side12, side13).orElse(0.0));
						area -= areaSegment(circle.getRadius(), Vector.angle(r1, r2).orElse(0.0));
						area += areaTriangle(circle.getRadius(), circle.getRadius(), new Vector(r1, r2).length());
					} else {
						area += areaSegment(circle.getRadius(), Vector.angle(side12, side13).orElse(0.0));
					}
				}
			}
			task.setArea(area);
			return task;
		} catch(DaoException e) {
			throw new ServiceException(e);
		}
	}

	public Integer save(Task task) throws ServiceException {
		try {
			if(task.getId() == null) {
				task.setCreated(new Date(0));
				return taskDao.create(task);
			} else {
				throw new RuntimeException("Update operation not implemented yet");
			}
		} catch(DaoException e) {
			throw new ServiceException(e);
		}
	}

	private static double areaTriangle(double a, double b, double c) {
		double p = (a + b + c) / 2;
		return Math.sqrt(p * (p - a) * (p - b) * (p - c));
	}

	private static double areaSegment(double radius, double angle) {
		return angle * radius * radius / 2;
	}

	private static Vector sum(Vector a, Vector b) {
		return new Vector(a.getX() + b.getX(), a.getY() + b.getY());
	}

	private static boolean equal(Point a, Point b) {
		return equal(a.getX(), b.getX()) && equal(a.getY(), b.getY());
	}

	private static boolean equal(double a, double b) {
		return Math.abs(a - b) < 0.001;
	}
}
