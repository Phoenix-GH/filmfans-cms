$(function () {
    var $treeContainer = $('#categories-tree');
    if (!$treeContainer.length) {
        return;
    }

    var treeData = $treeContainer.data('tree-json');
    $treeContainer.treeview({
        data: treeData,
        showTags: true,
        color: '#0c83ec'
    });
});