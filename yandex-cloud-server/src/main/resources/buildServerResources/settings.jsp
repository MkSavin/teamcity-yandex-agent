<%@ taglib prefix="props" tagdir="/WEB-INF/tags/props" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/include.jsp" %>
<%@ taglib prefix="l" tagdir="/WEB-INF/tags/layout" %>
<%@ taglib prefix="forms" tagdir="/WEB-INF/tags/forms" %>
<%@ taglib prefix="util" uri="/WEB-INF/functions/util" %>
<%@ taglib prefix="bs" tagdir="/WEB-INF/tags" %>
</table>
<jsp:useBean id="propertiesBean" scope="request" type="jetbrains.buildServer.controllers.BasePropertiesBean"/>
<jsp:useBean id="cons" class="jetbrains.buildServer.clouds.yandex.YandexConstants"/>
<jsp:useBean id="basePath" class="java.lang.String" scope="request"/>

<script type="text/javascript">
    BS.LoadStyleSheetDynamically("<c:url value='${resPath}settings.css'/>");
</script>

<div id="yandex-setting" data-bind="template: { afterRender: afterRender }">

    <table class="runnerFormTable">
    <l:settingsGroup title="Security Credentials">
        <tr>
            <th><label for="${cons.accessKey}">JSON private key: <l:star/></label></th>
            <td>
                <div data-bind="visible: showAccessKey || !isValidCredentials()"  style="display: none">
                    <div>Edit JSON key:</div>
                    <textarea name="prop:${cons.accessKey}" class="longField"
                              rows="5" cols="49"
                              data-bind="initializeValue: credentials().accessKey,
                              textInput: credentials().accessKey, event: {
                              dragover: function() { return false },
                              dragenter: function() { dragEnterHandler(); },
                              dragleave: function() { dragLeaveHandler(); },
                              drop: function(data, event) { return dropHandler(event) } },
                              css: { attentionComment: isDragOver }"><c:out
                              value="${propertiesBean.properties[cons.accessKey]}"/></textarea>
                    <span data-bind="css: {invisible: !validatingKey()}">
                        <i class="icon-refresh icon-spin"></i>
                    </span>
                </div>
                <a href="#" data-bind="click: function() { showAccessKey(true) }, visible: !showAccessKey()">Edit JSON key</a>
                <span class="smallNote">Specify the JSON private key.</span>
                <div data-bind="visible: hasFileReader">
                    <input type="file" data-bind="event: { change: function() { loadAccessKey($element.files[0]) } }"/>
                </div>
                <span class="error option-error" data-bind="validationMessage: credentials().accessKey"></span>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <span class="smallNote">
                    To start cloud build agents you need to assign <em>Editor</em> or <em>Admin</em> roles.
                    <bs:help urlPrefix="https://cloud.yandex.ru/docs/iam/operations/sa/assign-role-for-sa" file=""/><br/>
                    <span data-bind="css: {hidden: !loadingResources() && !validatingKey()}">
                        <i class="icon-refresh icon-spin"></i>
                    </span>
                </span>
                <span class="error option-error" data-bind="text: errorResources, css: {hidden: loadingResources}"></span>
            </td>
        </tr>
    </l:settingsGroup>
    </table>

    <bs:dialog dialogId="YandexImageDialog" title="Add Image" closeCommand="BS.YandexImageDialog.close()"
               dialogClass="YandexImageDialog" titleId="YandexImageDialogTitle">
        <table class="runnerFormTable">
            <tr>
                <th><label for="${cons.sourceImage}">Image: <l:star/></label></th>
                <td>
                    <select name="${cons.sourceImage}" class="longField ignoreModified"
                            data-bind="options: sourceImages, optionsCaption: '<Select image>',
                             optionsText: 'text', optionsValue: 'id', value: image().sourceImage"></select>
                    <i class="icon-refresh icon-spin" data-bind="css: {invisible: !loadingResources()}"></i>
                    <span class="error option-error" data-bind="validationMessage: image().sourceImage"></span>
                </td>
            </tr>
            <tr>
                <th><label for="${cons.zone}">Zone: <l:star/></label></th>
                <td>
                    <select name="${cons.zone}" class="longField ignoreModified"
                            data-bind="options: zones, optionsText: 'text', optionsValue: 'id',
                             value: image().zone"></select>
                    <i class="icon-refresh icon-spin" data-bind="css: {invisible: !loadingResources()}"></i>
                    <span class="error option-error" data-bind="validationMessage: image().zone"></span>
                </td>
            </tr>
            <tr>
                <th><label for="${cons.vmNamePrefix}">Agent name prefix: <l:star/></label></th>
                <td>
                    <input type="text" name="${cons.vmNamePrefix}" class="longField ignoreModified"
                           data-bind="textInput: image().vmNamePrefix"/>
                    <span class="smallNote">It must be unique per cloud profile</span>
                    <span class="error option-error" data-bind="validationMessage: image().vmNamePrefix"></span>
                </td>
            </tr>
            <tr>
                <th class="noBorder"></th>
                <td>
                    <input type="checkbox" name="${cons.growingId}" class="ignoreModified"
                           data-bind="checked: image().growingId"/>
                    <label for="${cons.growingId}">Use constantly growing id as a suffix</label>
                </td>
            </tr>
            <tr>
                <th><label for="${cons.maxInstancesCount}">Instances limit: <l:star/></label></th>
                <td>
                    <input type="text" name="${cons.maxInstancesCount}" class="longField ignoreModified"
                           data-bind="textInput: image().maxInstances"/>
                    <span class="smallNote">Maximum number of instances which can be started</span>
                    <span class="error option-error" data-bind="validationMessage: image().maxInstances"></span>
                </td>
            </tr>
            <tr>
                <th class="noBorder">Cores: <l:star/></th>
                <td>
                    <input type="text" name="${cons.machineCores}" class="longField ignoreModified"
                           data-bind="textInput: image().machineCores"/>
                    <span class="error option-error" data-bind="validationMessage: image().machineCores"></span>
                </td>
            </tr>
            <tr>
                <th class="noBorder">Memory in GB: <l:star/></th>
                <td>
                    <input type="text" name="${cons.machineMemory}" class="longField ignoreModified"
                           data-bind="textInput: image().machineMemory"/>
                    <span class="error option-error" data-bind="validationMessage: image().machineMemory"></span>
                </td>
            </tr>
            <tr>
                <th class="noBorder"></th>
                <td>
                    <input type="checkbox" name="${cons.preemptible}" class="ignoreModified"
                           data-bind="checked: image().preemptible"/>
                    <label for="${cons.preemptible}">Use preemptible VM Instances
                        <bs:help urlPrefix="https://cloud.yandex.ru/docs/compute/concepts/preemptible-vm" file=""/>
                    </label>
                </td>
            </tr>
            <tr class="advancedSetting">
                <th><label for="${cons.diskType}">Disk type:</label></th>
                <td>
                    <select name="${cons.diskType}" class="longField ignoreModified"
                            data-bind="options: diskTypes, optionsText: 'text', optionsValue: 'id',
                             value: image().diskType, optionsCaption: '<Not specified>'"></select>
                    <i class="icon-refresh icon-spin" data-bind="css: {invisible: !loadingResources()}"></i>
                </td>
            </tr>
            <tr>
                <th><label for="${cons.network}">Network: <l:star/></label></th>
                <td>
                    <select name="${cons.network}" class="longField ignoreModified"
                            data-bind="options: networks, optionsText: 'text', optionsValue: 'id',
                             value: image().network, css: {hidden: networks().length == 0}"></select>
                    <div class="longField inline-block" data-bind="css: {hidden: networks().length > 0}">
                        <span class="error option-error">No networks found in folder</span>
                    </div>
                    <i class="icon-refresh icon-spin" data-bind="css: {invisible: !loadingResources()}"></i>
                </td>
            </tr>
            <tr>
                <th class="noBorder"><label for="${cons.subnet}">Sub network:</label></th>
                <td>
                    <select name="${cons.subnet}" class="longField ignoreModified"
                            data-bind="options: subnets, optionsText: 'text', optionsValue: 'id',
                             optionsCaption: '<Not specified>', value: image().subnet"></select>
                    <i class="icon-refresh icon-spin" data-bind="css: {invisible: !loadingResources()}"></i>
                </td>
            </tr>
            <tr>
                <th class="noBorder"></th>
                <td>
                    <input type="checkbox" name="${cons.ipv6}" class="ignoreModified"
                           data-bind="checked: image().ipv6"/>
                    <label for="${cons.ipv6}">Allocate IPv6 address</label>
                </td>
            </tr>
            <tr class="advancedSetting">
                <th>Service Account:</th>
                <td>
                    <a href="#" data-bind="click: function(data) { showServiceAccount(true) }, visible: !showServiceAccount()">Edit service account</a>
                    <input type="text" name="${cons.serviceAccount}" class="longField ignoreModified"
                           data-bind="textInput: image().serviceAccount, visible: showServiceAccount()"/>
                    <span class="error option-error" data-bind="validationMessage: image().serviceAccount"></span>
                    <span class="smallNote" data-bind="visible: showServiceAccount()">
                        Specify id for service account. You need to assign <em>Service Account User</em> role to account specified in cloud profile.
                            <bs:help
                                    urlPrefix="https://cloud.yandex.ru/docs/iam/concepts/users/service-accounts"
                                    file=""/>
                    </span>
                </td>
            </tr>
            <tr class="advancedSetting">
                <th><label for="${cons.metadata}">Custom metadata:</label></th>
                <td>
                    <a href="#" data-bind="click: function(data) { showMetadata(true) }, visible: !showMetadata()">Edit metadata</a>
                    <textarea name="${cons.metadata}" class="longField ignoreModified" rows="3" cols="49"
                              data-bind="textInput: image().metadata, visible: showMetadata()"></textarea>
                    <span class="smallNote" data-bind="visible: showMetadata()">Specify the instance metadata in JSON format.
                        <bs:help urlPrefix="https://cloud.yandex.ru/docs/compute/concepts/vm-metadata" file=""/>
                    </span>
                    <span class="error option-error" data-bind="validationMessage: image().metadata"></span>
                </td>
            </tr>
            <tr class="advancedSetting">
                <th><label for="${cons.agentPoolId}">Agent pool:</label></th>
                <td>
                    <select name="prop:${cons.agentPoolId}" class="longField ignoreModified"
                            data-bind="options: agentPools, optionsText: 'text', optionsValue: 'id',
                        value: image().agentPoolId"></select>
                    <span id="error_${cons.agentPoolId}" class="error"></span>
                </td>
            </tr>
        </table>

        <div class="popupSaveButtonsBlock">
            <input type="submit" value="Save" class="btn btn_primary submitButton"
                   data-bind="click: saveImage, enable: image.isValid"/>
            <a class="btn" href="#" data-bind="click: closeDialog">Cancel</a>
        </div>
    </bs:dialog>

    <h2 class="noBorder section-header">Agent images</h2>
    <div class="imagesOuterWrapper">
        <div class="imagesTableWrapper">
            <span class="emptyImagesListMessage hidden"
                  data-bind="css: { hidden: images().length > 0 }">You haven't added any images yet.</span>
            <table class="settings yandex-settings imagesTable hidden"
                   data-bind="css: { hidden: images().length == 0 }">
                <thead>
                <tr>
                    <th class="name">Agent name prefix</th>
                    <th class="name">Cloud image</th>
                    <th class="name center" title="Maximum number of instances">Limit</th>
                    <th class="name center" colspan="2">Actions</th>
                </tr>
                </thead>
                <tbody data-bind="foreach: images">
                <tr>
                    <td class="nowrap" data-bind="text: $data['source-id']"></td>
                    <td class="nowrap" data-bind="text: sourceImage.slice(-80), attr: {title: sourceImage}"></td>
                    <td class="center edit" data-bind="text: maxInstances"></td>
                    <td class="edit">
                        <a href="#" data-bind="click: $parent.showDialog,
                        css: {hidden: !$parent.isValidCredentials() || $parent.loadingResources() || $parent.validatingKey()}">Edit</a>
                    </td>
                    <td class="remove edit"><a href="#" data-bind="click: $parent.deleteImage">Delete</a></td>
                </tr>
                </tbody>
            </table>

            <c:set var="sourceImagesData" value="${propertiesBean.properties[cons.imagesData]}"/>
            <c:set var="imagesData" value="${propertiesBean.properties['images_data']}"/>
            <input type="hidden" name="prop:${cons.imagesData}"
                   value="<c:out value="${empty sourceImagesData || sourceImagesData == '[]' ? imagesData : sourceImagesData}"/>"
                   data-bind="initializeValue: images_data, value: images_data"/>
        </div>

        <a class="btn" href="#" disabled="disabled"
           data-bind="click: (!isValidCredentials() || loadingResources() || errorResources()) ? false : showDialog.bind($data, null),
                      attr: {disabled: !isValidCredentials() || loadingResources() || errorResources() ? 'disabled' : null}">
            <span class="addNew">Add image</span>
        </a>
    </div>

</div>

<script type="text/javascript">
    BS.YandexImageDialog = OO.extend(BS.AbstractModalDialog, {
        getContainer: function () {
            return $('YandexImageDialog');
        },
        showDialog: function (addImage) {
            var action = addImage ? "Add" : "Edit";
            $j("#YandexImageDialogTitle").text(action + " Image");
            this.showCentered();
        }
    });

    $j.when($j.getScript("<c:url value="${resPath}knockout-3.4.0.js"/>").then(function () {
            return $j.when($j.getScript("<c:url value="${resPath}knockout.validation-2.0.3.js"/>"),
                $j.getScript("<c:url value="${resPath}knockout.extenders.js"/>"));
        }),
        $j.getScript("<c:url value="${resPath}images.vm.js"/>")
    ).then(function () {
        var dialog = document.getElementById("yandex-setting");
        ko.validation.init({insertMessages: false});
        ko.applyBindings(new YandexImagesViewModel($j, ko, BS.YandexImageDialog, {
            baseUrl: "<c:url value='${basePath}'/>",
            projectId: "${projectId}"
        }), dialog);
    });
</script>
<table class="runnerFormTable">
