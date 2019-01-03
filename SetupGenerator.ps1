Param
(
    [Parameter(Mandatory = $true)]
    [String] $Module,
    [String] $Controller,
    [Parameter(Mandatory = $true)]
    [String] $Entity
)

$userName = $env:username
$date = Get-Date -Format dd-MM-yyyy

$actionLog = "`n`n/**`n* Created By " + $userName + " on "+ $date+"`n**/" 
Write-Host("\** `n* Created By " + $userName + " on "+ $date+"`n **\")
$pathVal = Get-Content path.txt 

Write-Host("Root-path: "+ $pathVal)
$pathRepo = $pathVal + "\src\main\java\com\sit\jbc\repository\" + $Module + "\" + $Entity + "Repository.java"


# Repository Creation Part

$repoContent = "package com.sit.jbc.repository."+$Module+";
`nimport com.sit.jbc.domain.entity."+$Module+"."+$Entity+";
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
"+$actionLog+"
`n`npublic interface "+$Entity+"Repository extends JpaRepository<"+$Entity+", Long> {
    
}"
New-Item -Path $pathRepo -itemType File
Set-Content  $pathRepo $repoContent


# Service Creation Part
$serviceContent = "package com.sit.jbc.service."+$Module+";
`nimport com.sit.jbc.domain.entity."+$Module+"."+$Entity+";
import java.util.List;
"+$actionLog+"
public interface "+$Entity+"Service {
    "+$Entity+" save("+$Entity+" "+$Entity.ToLower()+");
    void delete("+$Entity+" "+$Entity.ToLower()+");
    "+$Entity+" get"+$Entity+"(Long id);
    List<"+$Entity+">  findAll();
}"

$pathService = $pathVal + "\src\main\java\com\sit\jbc\service\" + $Module +  "\" + $Entity + "Service.java"
New-Item -Path $pathService -itemType File
Set-Content $pathService $serviceContent

# Service Implementation Part
$serviceImplContent = "package com.sit.jbc.service."+$Module+".impl;
`nimport com.sit.jbc.domain.entity."+$Module+"."+$Entity+";
import com.sit.jbc.repository."+$Module+".*;
import com.sit.jbc.service."+$Module+"."+$Entity+"Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
`nimport java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

`n`n@Service
public class "+$Entity+"ServiceImpl implements "+$Entity+"Service{
    @Autowired
    "+$Entity+"Repository "+$Entity.ToLower()+"Repository;

    @Override
    public "+$Entity+" save("+$Entity+" "+$Entity.ToLower()+"){
            return "+$Entity.ToLower()+"Repository.save("+$Entity.ToLower()+");
    }

    @Override
    public void delete("+$Entity+" "+$Entity.ToLower()+"){
        "+$Entity.ToLower()+"Repository.delete("+$Entity.ToLower()+");
    }

    @Override
    public "+$Entity+" get"+$Entity+"(Long id){
         return null;
    }

    @Override
    public List<"+$Entity+"> findAll(){
        return "+$Entity.ToLower()+"Repository.findAll();
    }

}"
$pathServiceImpl = $pathVal + "\src\main\java\com\sit\jbc\service\" + $Module +  "\impl\" + $Entity + "ServiceImpl.java"
New-Item -Path $pathServiceImpl -itemType File
Set-Content $pathServiceImpl $serviceImplContent

Write-Host("Path Repository: " + $pathRepo)
Write-Host("Path Service: "+$pathService)
Write-Host("Path Service Impl: " + $pathServiceImpl)




if($Controller -eq 1){
    #Controller Creation and Management Part.
    $controllerContent = "package com.sit.jbc.controller."+$Module+";
`nimport com.sit.jbc.common.BaseResponse;
import com.sit.jbc.domain.dto.security.AccessPermission;
import com.sit.jbc.domain.dto.security.SessionUser;
import com.sit.jbc.common.BaseResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
`nimport com.sit.jbc.domain.entity."+$Module+"."+$Entity+";
import com.sit.jbc.service."+$Module+"."+$Entity+"Service;
"+$actionLog+"
@RequestMapping(value = ""/"+$Module+""")
@Controller
public class "+$Entity+"Controller {
    @Autowired
    "+$Entity+"Service "+$Entity.ToLower()+"Service;
`n}"
    $pathController = $pathVal + "\src\main\java\com\sit\jbc\controller\" + $Module + "\" + $Entity + "Controller.java"
    Write-Host("Path Controller: "+ $pathController)
   New-Item -Path $pathController -itemType File
   Set-Content $pathController $controllerContent

    #htmlPart
    $viewContent = "<html  xmlns=""http://www.w3.org/1999/xhtml""
       xmlns:th=""http://www.thymeleaf.org""
       xmlns:layout=""http://www.ultraq.net.nz/thymeleaf/layout""
       layout:decorator=""common/layout/base"">
<head>
    <link href=""http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.css""
          rel=""stylesheet""  type='text/css'>
</head>
<div layout:fragment=""content"">
    <div class="""" "+$Entity.ToLower()+"=""main"">
        <div class=""row"">
            <div class=""col-md-12 col-sm-12 col-xs-12"">
            </div>
            <div class=""x_panel"">
                <div class=""x_title"">
                    <h2><small> "+$Module+" > "+$Entity+" Setup </small></h2>
                        <ul class=""nav navbar-right panel_toolbox"">
                            <li><a class=""collapse-link""><i class=""fa fa-chevron-up""></i></a>
                            </li>
                        </ul>
                        <div class=""clearfix""></div>
                </div>
                <div class=""x_content"">
                    <form name=""add"" class=""form-horizontal form-label-left"" id=""add"" th:action=""@{/generic/division}"" th:object="""+$Entity.ToLower()+""" method="post">

                    </form>
                    <div class=""clearfix""></div>
                </div>
            </div>
            <div class=""clearfix""></div>
        </div>
    </div>
</div>
<div layout:fragment=""script"">
</div>
<div layout:fragment=""css"">
</div>
</html>
"

    $pathView = $pathVal + "\src\main\resources\templates\" + $Module + "\" + $Entity.ToLower() + ".html"
    Write-Host("Path View: " + $pathView)
  
    #New-Item -Path $pathView -itemType File
    #Set-Content $pathView $viewContent
    #jsPart
    $doc = "document"
    $jsContent ="$("+$doc+").ready(function(){

    });"
    $pathJs = $pathVal + "\src\main\resources\static\js\" + $Module +  "\" + $Entity.ToLower() + ".js"
    Write-Host("Path Js: " + $pathJs)
    New-Item -Path $pathJs -itemType File
    SetContent $pathJs $jsContent

    #cssPart
    $cssContent = $actionLog
    $pathCss = $pathVal + "\src\main\resources\static\css\" + $Module + "\" + $Entity.ToLower() +".css"
   # New-Item -Path $pathCss -itemType File
    Set-Content $pathCss $cssContent
    New-Item -Path $pathCss -itemType File
    Write-Host("Path Css: "+ $pathCss)
}
