-- YOUTUBE LINK  -- >     https://www.youtube.com/watch?v=OCWvlZ0a9DY
-- 18 minute completed

select * from jdr_paths

SELECT * FROm FWK_TBX_ADDRESSES

select * from jdr_components

exec jdr_utils.printdocument('/oracle/apps/per/selfservice/common/webui/RLSummaryContainerRN.SummaryContainerRN')


exec jdr_utils.printdocument('/oracle/apps/per/selfservice/common/webui/RLSummaryContainerRN');

select * from jdr_paths where path_name ='SummaryContainerRN'


select path_name, path_docid, jdr_mds_internal.getdocumentname (path_docid) from jdr_paths  where path_name ='SummaryContainerRN'

select path_name, path_docid, jdr_mds_internal.getdocumentname (path_docid) from jdr_paths  where path_name ='RLSummaryContainerRN'

select * from jdr_components where  comp_docid = 89788 --37103 

select * from jdr_attributes where att_comp_docid = 89788


/*
EKHANE  JDR ER TABLE GULO ASE
JDR_UTILS PL/SQL package supports the MDS repository and can be used to query and maintain the repository.
Now let’s see how, all that is mentioned above, happens.
MDS repository has 4 tables in all. Just 4 tables? Yes you heard it right it has only 4 tables and that’s it. These 4 tables can manage all the stuff that we have discussed till now.
These 4 tables are:
1. JDR_PATHS: Stores the path of the documents, OA Framework pages and their parent child relationship.
2. JDR_COMPONENTS: Stores components on documents and OA Framework pages.
3. JDR_ATTRIBUTES: Stores attributes of components on documents and OA Framework pages.
4. JDR_ATTRIBUTES_TRANS: Stores translated attribute values of document components or OA framework pages
*/

