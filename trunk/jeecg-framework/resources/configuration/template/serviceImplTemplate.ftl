package ${bussiPackage}.service.impl.${entityPackage};

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import sun.util.MyBeanUtils;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import sy.dao.BaseDaoI;
import ${bussiPackage}.entity.${entityPackage}.${entityName}Entity;
import sy.pageModel.DataGrid;
import ${bussiPackage}.page.${entityPackage}.${entityName}Page;
import sy.service.impl.BaseServiceImpl;
import ${bussiPackage}.service.${entityPackage}.${entityName}ServiceI;
import sun.util.dbcommon.SearchSqlGenerateUtil;
import sy.dao.jdbc.JdbcDao;

/**   
 * @Title: ServiceImpl
 * @Description: ${ftl_description}
 * @author zhangdaihao
 * @date ${ftl_create_time}
 * @version V1.0   
 *
 */
@Service("${entityName?uncap_first}Service")
public class ${entityName}ServiceImpl extends BaseServiceImpl implements ${entityName}ServiceI {

	@Autowired
	//SQL 使用JdbcDao
	private JdbcDao jdbcDao;
	private BaseDaoI<${entityName}Entity> ${entityName?uncap_first}EntityDao;

	public BaseDaoI<${entityName}Entity> get${entityName}EntityDao() {
		return ${entityName?uncap_first}EntityDao;
	}
	@Autowired
	public void set${entityName}EntityDao(BaseDaoI<${entityName}Entity> ${entityName?uncap_first}EntityDao) {
		this.${entityName?uncap_first}EntityDao = ${entityName?uncap_first}EntityDao;
	}

	@Transactional(propagation = Propagation.SUPPORTS)
	public DataGrid datagrid(${entityName}Page ${entityName?uncap_first}Page) {
		DataGrid j = new DataGrid();
		j.setRows(getPagesFromEntitys(find(${entityName?uncap_first}Page)));
		j.setTotal(total(${entityName?uncap_first}Page));
		return j;
	}

	private List<${entityName}Page> getPagesFromEntitys(List<${entityName}Entity> ${entityName?uncap_first}Entitys) {
		List<${entityName}Page> ${entityName?uncap_first}Pages = new ArrayList<${entityName}Page>();
		if (${entityName?uncap_first}Entitys != null && ${entityName?uncap_first}Entitys.size() > 0) {
			for (${entityName}Entity tb : ${entityName?uncap_first}Entitys) {
				${entityName}Page b = new ${entityName}Page();
				BeanUtils.copyProperties(tb, b);
				${entityName?uncap_first}Pages.add(b);
			}
		}
		return ${entityName?uncap_first}Pages;
	}

	private List<${entityName}Entity> find(${entityName}Page ${entityName?uncap_first}Page) {
		String hql = "from ${entityName}Entity t where 1=1 ";

		List<Object> values = new ArrayList<Object>();
		hql = addWhere(${entityName?uncap_first}Page, hql, values);

		if (${entityName?uncap_first}Page.getSort() != null && ${entityName?uncap_first}Page.getOrder() != null) {
			hql += " order by " + ${entityName?uncap_first}Page.getSort() + " " + ${entityName?uncap_first}Page.getOrder();
		}
		return ${entityName?uncap_first}EntityDao.find(hql, ${entityName?uncap_first}Page.getPage(), ${entityName?uncap_first}Page.getRows(), values);
	}

	private Long total(${entityName}Page ${entityName?uncap_first}Page) {
		String hql = "select count(*) from ${entityName}Entity t where 1=1 ";
		List<Object> values = new ArrayList<Object>();
		hql = addWhere(${entityName?uncap_first}Page, hql, values);
		return ${entityName?uncap_first}EntityDao.count(hql, values);
	}

	private String addWhere(${entityName}Page ${entityName?uncap_first}Page, String hql, List<Object> values) {
	    //循环查询条件Page的所有[Integer][String]类型的字段，如果字段不为空则动态加上查询条件
		//-----------------------------------------------------
		StringBuffer hqlbf = new StringBuffer(hql);
		
		${entityName}Entity ${entityName?uncap_first}Entity = new ${entityName}Entity();
		BeanUtils.copyProperties(${entityName?uncap_first}Page, ${entityName?uncap_first}Entity);
		SearchSqlGenerateUtil.createSearchParamsHql(hqlbf, values, ${entityName?uncap_first}Entity);
		hql = hqlbf.toString();
		//-----------------------------------------------------
		if (${entityName?uncap_first}Page.getCcreatedatetimeStart() != null) {
			hql += " and createDt>=? ";
			values.add(${entityName?uncap_first}Page.getCcreatedatetimeStart());
		}
		if (${entityName?uncap_first}Page.getCcreatedatetimeEnd() != null) {
			hql += " and createDt<=? ";
			values.add(${entityName?uncap_first}Page.getCcreatedatetimeEnd());
		}
		if (${entityName?uncap_first}Page.getCmodifydatetimeStart() != null) {
			hql += " and modifyDt>=? ";
			values.add(${entityName?uncap_first}Page.getCmodifydatetimeStart());
		}
		if (${entityName?uncap_first}Page.getCmodifydatetimeEnd() != null) {
			hql += " and modifyDt<=? ";
			values.add(${entityName?uncap_first}Page.getCmodifydatetimeEnd());
		}
		return hql;
	}

	public void add(${entityName}Page ${entityName?uncap_first}Page) {
		if (${entityName?uncap_first}Page.getObid() == null || ${entityName?uncap_first}Page.getObid().trim().equals("")) {
			${entityName?uncap_first}Page.setObid(UUID.randomUUID().toString());
		}
		${entityName}Entity t = new ${entityName}Entity();
		BeanUtils.copyProperties(${entityName?uncap_first}Page, t);
		${entityName?uncap_first}EntityDao.save(t);
	}

	public void update(${entityName}Page ${entityName?uncap_first}Page) throws Exception {
		${entityName}Entity t = ${entityName?uncap_first}EntityDao.get(${entityName}Entity.class, ${entityName?uncap_first}Page.getObid());
	    if(t != null) {
			MyBeanUtils.copyBeanNotNull2Bean(${entityName?uncap_first}Page, t);
		}
	}

	public void delete(String ids) {
		if (ids != null) {
			for (String id : ids.split(",")) {
				${entityName}Entity t = ${entityName?uncap_first}EntityDao.get(${entityName}Entity.class, id);
				if (t != null) {
					${entityName?uncap_first}EntityDao.delete(t);
				}
			}
		}
	}

	public ${entityName}Entity get(${entityName}Page ${entityName?uncap_first}Page) {
		return ${entityName?uncap_first}EntityDao.get(${entityName}Entity.class, ${entityName?uncap_first}Page.getObid());
	}

	public ${entityName}Entity get(String obid) {
		return ${entityName?uncap_first}EntityDao.get(${entityName}Entity.class, obid);
	}
	public List<${entityName}Entity> listAll(${entityName}Page ${entityName?uncap_first}Page) {
		String hql = "from ${entityName}Entity where 1 = 1 ";
		List<Object> values = new ArrayList<Object>();
		hql = addWhere(${entityName?uncap_first}Page, hql, values);
		List<${entityName}Entity> list = ${entityName?uncap_first}EntityDao.find(hql,values);
		return list;
	}
}
