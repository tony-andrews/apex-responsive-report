set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,1055016597152790));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,20011);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/dynamic_action/com_tacl_makeresp
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 26570110451702919 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'DYNAMIC ACTION'
 ,p_name => 'COM.TACL.MAKERESP'
 ,p_display_name => 'TACL Make reports responsive'
 ,p_category => 'STYLE'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'function render_make_report_responsive'||unistr('\000a')||
'   ( p_dynamic_action apex_plugin.t_dynamic_action'||unistr('\000a')||
'   , p_plugin         apex_plugin.t_plugin '||unistr('\000a')||
'   ) return           apex_plugin.t_dynamic_action_render_result'||unistr('\000a')||
'is'||unistr('\000a')||
'   l_report_container_class long := p_plugin.attribute_01;'||unistr('\000a')||
'   l_report_table_class     long := p_plugin.attribute_02;'||unistr('\000a')||
'   l_media_max_width        long := nvl(p_dynamic_action.attribute_01,''760'');'||unistr('\000a')||
'  '||
' l_result                 apex_plugin.t_dynamic_action_render_result;'||unistr('\000a')||
'   l_app_id                 long := v(''APP_ID'');'||unistr('\000a')||
''||unistr('\000a')||
'   procedure render_common_css '||unistr('\000a')||
'      ( p_table_class      varchar2'||unistr('\000a')||
'      , p_div_class        varchar2'||unistr('\000a')||
'      )'||unistr('\000a')||
'   is'||unistr('\000a')||
'      l_css long;'||unistr('\000a')||
'   begin'||unistr('\000a')||
'      l_css := q''['||unistr('\000a')||
'@media only screen and (max-width: #MAX_WIDTH#px) {'||unistr('\000a')||
'div.#DIV_CLASS#, table.#TABLE_CLASS#{ '||unistr('\000a')||
'width: 100%; '||unistr('\000a')||
'border-coll'||
'apse: collapse; '||unistr('\000a')||
'}'||unistr('\000a')||
''||unistr('\000a')||
'/* Force table to not be like tables anymore */'||unistr('\000a')||
'table.#TABLE_CLASS#, .#TABLE_CLASS# thead, .#TABLE_CLASS# tbody, .#TABLE_CLASS# th, .#TABLE_CLASS# td, .#TABLE_CLASS# tr {'||unistr('\000a')||
'display: block; }'||unistr('\000a')||
''||unistr('\000a')||
'.#TABLE_CLASS# thead tr {'||unistr('\000a')||
'position: absolute;'||unistr('\000a')||
'top: -9999px;'||unistr('\000a')||
'left: -9999px; }'||unistr('\000a')||
''||unistr('\000a')||
'.#TABLE_CLASS# tr {'||unistr('\000a')||
'border: 1px solid #ccc; }'||unistr('\000a')||
''||unistr('\000a')||
'.#TABLE_CLASS# td {'||unistr('\000a')||
'border: none;'||unistr('\000a')||
'border-bottom: 1px solid #eee;'||unistr('\000a')||
''||
'position: relative;'||unistr('\000a')||
'padding-left: 50%; '||unistr('\000a')||
'text-align: left;'||unistr('\000a')||
'}'||unistr('\000a')||
''||unistr('\000a')||
'.#TABLE_CLASS# td:before {'||unistr('\000a')||
'position: absolute;'||unistr('\000a')||
'top: 6px;'||unistr('\000a')||
'left: 6px;'||unistr('\000a')||
'width: 45%;'||unistr('\000a')||
'padding-right: 10px;'||unistr('\000a')||
'white-space: normal;'||unistr('\000a')||
'font-weight: bold;'||unistr('\000a')||
'white-space: normal; }'||unistr('\000a')||
'}'||unistr('\000a')||
']'';'||unistr('\000a')||
'      l_css := replace (l_css, ''#TABLE_CLASS#'', p_table_class);'||unistr('\000a')||
'      l_css := replace (l_css, ''#DIV_CLASS#'', p_div_class);'||unistr('\000a')||
'      l_css := replace (l_css, ''#MAX_WIDTH#'','||
' l_media_max_width);'||unistr('\000a')||
'      '||unistr('\000a')||
'      apex_css.add'||unistr('\000a')||
'         ( p_css => l_css'||unistr('\000a')||
'         , p_key => ''common_css'''||unistr('\000a')||
'         );'||unistr('\000a')||
'   end render_common_css;'||unistr('\000a')||
''||unistr('\000a')||
'   procedure render_report_css '||unistr('\000a')||
'      ( p_region_static_id varchar2'||unistr('\000a')||
'      , p_region_id        varchar2'||unistr('\000a')||
'      , p_table_class      varchar2'||unistr('\000a')||
'      )'||unistr('\000a')||
'   is '||unistr('\000a')||
'      l_report_column_headings long;'||unistr('\000a')||
'      l_headings_type long;'||unistr('\000a')||
'      l_headings_tab apex_applicati'||
'on_global.vc_arr2;'||unistr('\000a')||
'      l_col_css long;'||unistr('\000a')||
'      l_css long;'||unistr('\000a')||
'   begin'||unistr('\000a')||
'      l_css := ''/*'' || p_region_static_id || ''*/ '';'||unistr('\000a')||
'      l_css := l_css || ''@media only screen and (max-width: #MAX_WIDTH#px) {'';'||unistr('\000a')||
'      l_css := replace (l_css, ''#MAX_WIDTH#'', l_media_max_width);'||unistr('\000a')||
''||unistr('\000a')||
'      select report_column_headings, headings_type'||unistr('\000a')||
'        into l_report_column_headings, l_headings_type'||unistr('\000a')||
'        from apex_applicatio'||
'n_page_regions'||unistr('\000a')||
'       where application_id = l_app_id'||unistr('\000a')||
'         and region_id = p_region_id; '||unistr('\000a')||
''||unistr('\000a')||
'      case l_headings_type'||unistr('\000a')||
'      when ''FUNCTION_BODY_RETURNING_COLON_DELIMITED_LIST'' then'||unistr('\000a')||
'         if trim(l_report_column_headings) not like ''%;'' then '||unistr('\000a')||
'            l_report_column_headings := l_report_column_headings || '';'';'||unistr('\000a')||
'         end if;'||unistr('\000a')||
'         execute immediate ''declare function ff return varchar2'||
' is begin '' || l_report_column_headings || '' end; begin :out := ff(); end;'' using out l_report_column_headings;'||unistr('\000a')||
'         l_headings_tab := apex_util.string_to_table (l_report_column_headings);'||unistr('\000a')||
'      when ''NO_HEADINGS'' then'||unistr('\000a')||
'         null;'||unistr('\000a')||
'      else'||unistr('\000a')||
'         select case l_headings_type'||unistr('\000a')||
'                   when ''QUERY_COLUMNS'' then column_alias'||unistr('\000a')||
'                   when ''QUERY_COLUMNS_INITCAP'' then ini'||
'tcap(column_alias)'||unistr('\000a')||
'                   else heading'||unistr('\000a')||
'                   end'||unistr('\000a')||
'           bulk collect into l_headings_tab'||unistr('\000a')||
'           from apex_application_page_rpt_cols'||unistr('\000a')||
'          where application_id = l_app_id'||unistr('\000a')||
'            and region_id = p_region_id'||unistr('\000a')||
'            and column_is_hidden=''No'''||unistr('\000a')||
'            order by display_sequence;'||unistr('\000a')||
'      end case;'||unistr('\000a')||
''||unistr('\000a')||
'      -- Render CSS to display the column headings to left '||
'of data      '||unistr('\000a')||
'      for i in 1..l_headings_tab.count'||unistr('\000a')||
'      loop'||unistr('\000a')||
'         l_col_css := ''##REGION_STATIC_ID# .#TABLE_CLASS# td:nth-of-type(#N#):before { content: "#HEADING#"; }'';'||unistr('\000a')||
'         l_col_css := replace (l_col_css, ''#REGION_STATIC_ID#'', p_region_static_id);'||unistr('\000a')||
'         l_col_css := replace (l_col_css, ''#TABLE_CLASS#'', p_table_class);'||unistr('\000a')||
'         l_col_css := replace (l_col_css, ''#N#'', i);'||unistr('\000a')||
'         l'||
'_col_css := replace (l_col_css, ''#HEADING#'', apex_escape.html(l_headings_tab(i)));'||unistr('\000a')||
'         l_css := l_css || l_col_css;'||unistr('\000a')||
'      end loop;'||unistr('\000a')||
'      '||unistr('\000a')||
'      -- End the media query'||unistr('\000a')||
'      l_css := l_css || ''}'';'||unistr('\000a')||
'      apex_css.add'||unistr('\000a')||
'         ( p_css => l_css'||unistr('\000a')||
'         , p_key => ''css-''||p_region_static_id'||unistr('\000a')||
'         );'||unistr('\000a')||
'   end render_report_css;'||unistr('\000a')||
''||unistr('\000a')||
'begin'||unistr('\000a')||
'  -- Debug'||unistr('\000a')||
'  if apex_application.g_debug then'||unistr('\000a')||
'    apex_plugin'||
'_util.debug_dynamic_action'||unistr('\000a')||
'       ( p_plugin         => p_plugin'||unistr('\000a')||
'       , p_dynamic_action => p_dynamic_action'||unistr('\000a')||
'       );'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  render_common_css'||unistr('\000a')||
'     ( p_table_class => l_report_table_class'||unistr('\000a')||
'     , p_div_class => l_report_container_class'||unistr('\000a')||
'     );   '||unistr('\000a')||
''||unistr('\000a')||
'  for r in'||unistr('\000a')||
'     ( select nvl( apex_application_page_regions.static_id'||unistr('\000a')||
'                 , ''R'' || apex_application_page_regions.region_id'||unistr('\000a')||
'        '||
'         ) AS static_id'||unistr('\000a')||
'            , region_id'||unistr('\000a')||
'         from apex_application_page_regions'||unistr('\000a')||
'        where apex_application_page_regions.application_id = l_app_id'||unistr('\000a')||
'          and apex_application_page_regions.region_id IN'||unistr('\000a')||
'              (select apex_application_page_da_acts.affected_region_id'||unistr('\000a')||
'                 from apex_application_page_da_acts'||unistr('\000a')||
'                where apex_application_page_da_acts.applic'||
'ation_id = l_app_id'||unistr('\000a')||
'                  and apex_application_page_da_acts.affected_elements_type = ''Region'''||unistr('\000a')||
'                  and apex_application_page_da_acts.action_id = p_dynamic_action.id'||unistr('\000a')||
'              )'||unistr('\000a')||
'      )'||unistr('\000a')||
'   loop'||unistr('\000a')||
'      render_report_css'||unistr('\000a')||
'         ( p_region_static_id => r.static_id'||unistr('\000a')||
'         , p_region_id        => r.region_id'||unistr('\000a')||
'         , p_table_class => l_report_table_class'||unistr('\000a')||
'         );   '||unistr('\000a')||
''||
'   end loop;'||unistr('\000a')||
''||unistr('\000a')||
'   -- No real Javascript required'||unistr('\000a')||
'   l_result.javascript_function := q''[ function () {}]'';'||unistr('\000a')||
''||unistr('\000a')||
'   return l_result;'||unistr('\000a')||
'end;'
 ,p_render_function => 'render_make_report_responsive'
 ,p_standard_attributes => 'REGION'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_help_text => '<p>'||unistr('\000a')||
'	Apply this dynamic action to a report region to make it appear as a vertical report on small devices.</p>'||unistr('\000a')||
''
 ,p_version_identifier => '1.0'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 26570728986709523 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 26570110451702919 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'CSS class of report container'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_help_text => 'Class of div containing the report, which will be set to 100% width for small screens by this action'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 26572628973724720 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 26570110451702919 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'CSS class of report data table'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_help_text => 'Class of table containing the report data'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 26570403119706370 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 26570110451702919 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Max screen width (px) affected '
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_default_value => '760'
 ,p_is_translatable => false
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
