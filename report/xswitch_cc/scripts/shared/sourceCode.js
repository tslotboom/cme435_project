/* global CodeMirror, GLOBAL_JSON, dataObj */
/* exported createCodeMirrorInstance, addHitsGutters, addMarkers, jumpToLine, onCodeMirrorGutterClick */

// create codemirror instance
function createCodeMirrorInstance(id, tabId, guttersCount, sourceFileInfo) {
    var gutterClasses = '';
    var gutters = ['CodeMirror-linenumbers'];
    //Appending gutters depending on the number of items
    for (var i = 1; i <= guttersCount; i++) {
        gutters.push('codemirror-gut' + i);
        gutterClasses +=
            '.codemirror-gut' + i + ' { ' +
                'width: 60px; background: #f1f1f1; border-right: 1px solid #d4cccc;' +
            '}';
    }
    //Appending fold gutter
    gutters.push('CodeMirror-foldgutter');
    $('head').append('<style>' + gutterClasses + '</style>');

    var textAreaId = 'textArea' + tabId;
    $(id).append('<textarea id="' + textAreaId + '"></textarea>');
    var editor = CodeMirror.fromTextArea($('#' + textAreaId)[0], {
        mode: sourceFileInfo.mode,
        theme: 'default',
        lineNumbers: true,
        indentUnit: 4,
        gutters: gutters,
        foldGutter: {
            rangeFinder: new CodeMirror.fold.combine(CodeMirror.fold.hdl, CodeMirror.fold.comment, CodeMirror.fold.indent)
        },
        readOnly: true,
        matchBrackets: true,
        autoCloseBrackets: true,
        autofocus: true,
        autoRefresh: true,
        styleActiveLine: true
    });

    editor.getDoc().setValue(sourceFileInfo.code);

    return editor;
}
//Rendering hits in the gutters
function addHitsGutters(editor, lineNum, item, hits, exclId, exclComment, thData) {
    var template;
    var imgSource;
    var imgExtraAttr = '';
    var imgExtraClasses = '';
    var divExtraAttr = '';
    var divExtraClasses = '';

    var isGenBlkExist = (typeof hits === 'object');
    var isHitsExlcuded  = (typeof hits === 'string');
    var isExclWithCommentOrIsgenBlk = (exclComment || GLOBAL_JSON.exclReason.hasOwnProperty(hits) || (hits == 'E-hit' && exclComment) || isGenBlkExist); //Excluded with comment or generate block exist

    if (isHitsExlcuded  || isGenBlkExist) { //hits gutter incase of Exclusion or generate blocks.

        if (isExclWithCommentOrIsgenBlk) {
            imgExtraClasses = 'img-comment';
            divExtraClasses = 'excl-comment';
            if (isGenBlkExist) {
                imgSource = 'icons/gi.png';                 //generate blocks icon
                imgExtraClasses = 'img-comment';
                divExtraClasses = getGenBlockHits(hits);
            } else if (hits == 'E-hit') {
                imgSource = 'icons/echeckcomment.png';      //Excluded and hit with comment icon
            } else if (exclComment) {
                imgSource = 'icons/ecomment.png';           //Excluded with comment icon
            } else {
                imgSource = 'icons/exclude.png';            //Excluded icon
            }

            if (thData) {
                imgExtraAttr = 'style="height: 20px;width: 20px; float: left;margin-right: 5px;margin-left: 11px;" excl="' + exclId + '"';
                divExtraAttr = 'excl="' + exclId  + '"' + 'line="' + lineNum  + '"' + 'item="' + item  + '"';
            } else {
                imgExtraAttr = 'style="height: 20px;width: 20px" excl="' + exclId + '"' ;
                divExtraAttr = 'excl="' + exclId  + '"' ;
            }

        } else {
            imgSource = (hits == 'E-hit') ? 'icons/echeck.png' : 'icons/exclude.png';

            if (thData) {
                imgExtraAttr = 'style="height: 17px;width: 17x; float: left;margin-right: 5px;margin-left: 11px;"';
                divExtraAttr = 'excl="' + exclId  + '"' + 'line="' + lineNum  + '"' + 'item="' + item  + '"';
            } else {
                imgExtraAttr = 'style="height: 17px;width: 17x"' ;
            }

            divExtraClasses = 'excl';
        }

        if (thData) {
            template = '<div class="excl-item ' + divExtraClasses + '" ' + divExtraAttr + '><img src="' + imgSource + '" class="center-img ' + imgExtraClasses + '" alt="E" ' + imgExtraAttr + '" onclick="onCodeMirrorGutterClick(event)"></img> <i class="fa fa-flask" aria-hidden="true" style="color: black;font-size: 20px;" onclick="thdModal(event)"></i> <i id= "thdCheck" class="fa fa-check" style="position: absolute;margin-left: 40px;display: block;color: #11ef06;margin-top: -18px;font-size: 18px;z-index: 30;"onclick="thdModal(event)"></i></div>';
        } else {
            template = '<div class="excl-item ' + divExtraClasses + '" ' + divExtraAttr + '><img src="' + imgSource + '" class="center-img ' + imgExtraClasses + '" alt="E" ' + imgExtraAttr + '" onclick="onCodeMirrorGutterClick(event)"></img></div>';
        }

    } else { //Normal hits gutter "just the value"

        if (thData) {
            divExtraAttr = 'excl="' + exclId  + '"' + 'line="' + lineNum  + '"' + 'item="' + item  + '"';            //Extra attributes to get the line, item number in the Thd modal
        }

        //Constructing gutters template
        if (thData && hits != 0) {
            template = '<p class="' + (hits == 0 ? 'src-gut-not-hit' : 'src-gut-hit') + '" ' + divExtraAttr + '>' + hits + '  <i class="fa fa-flask" aria-hidden="true" style="color: black;font-size: 20px;" onclick="thdModal(event)"></i> <i id= "thdCheck" class="fa fa-check" style="position: absolute;margin-left: 33px;display: block;color: #11ef06;margin-top: -21px;font-size: 18px;z-index: 30;"onclick="thdModal(event)"></i></p>';   //adding flask icon incase of testhit data exist
        } else {
            template = '<p class="' + (hits == 0 ? 'src-gut-not-hit' : 'src-gut-hit') + '">' + hits + ' </p>';
        }
    }

    editor.doc.setGutterMarker(lineNum, 'codemirror-gut' + item, $(template)[0]);
}

// Get Genrate block total Hits/Miss Class
function getGenBlockHits(hits) {
    var hit = true;
    hits.forEach(function(element) {
        if (!element.h) {
            hit = false;
        }
    });
    return hit ? 'src-gut-hit' : 'src-gut-not-hit';
}

//Highlighting text in code editor
function addMarkers(editor, markers, line1, startCh, line2, endCH, hits, clearAll) {
    var className = hits == 0 ? 'src-highlight-not-hit' : 'src-highlight-hit';

    if (clearAll) {
        markers.forEach(function(marker) {
            marker.clear();
        });
    }

    markers.push(editor.doc.markText({line: line1, ch: startCh}, {line: line2, ch: endCH}, { className: className }));
}
//Jumping to specific line
function jumpToLine (editor, line) {
    editor.setCursor(line);

    var activeElements = $('.CodeMirror-activeline');

    if (activeElements.length) {
        activeElements[0].scrollIntoView();
    }
}

//onCodeMirrorGutterClick event handler, constructing template for showing exclsuion comment, reason or generate block.
function onCodeMirrorGutterClick (e) {
    var exclId = e.path[0].attributes.excl;
    var scope = exclId.nodeValue.split(',').map(Number);

    if (exclId) {
        var comment = dataObj.stmts[scope[0]].cov[scope[1]].i[scope[2]].ec;
        var genBlk;
        if (typeof dataObj.stmts[scope[0]].cov[scope[1]].i[scope[2]].h === 'object') {
            genBlk = '';
            dataObj.stmts[scope[0]].cov[scope[1]].i[scope[2]].h.forEach(function(item) {
                genBlk += '<span> &nbsp;&nbsp;&nbsp;' + item.h + item.gi + '</span> </br>';
            });
        }
        var reason = GLOBAL_JSON.exclReason[dataObj.stmts[scope[0]].cov[scope[1]].i[scope[2]].h];

        if (comment || reason || genBlk) {
            var template =
                '<div class="well excl-tooltip" id="hoverTooltip">' +
                    '<div class="arrow-left"></div>' +
                    '<span class="excl-comment-text">' +
                        ((typeof genBlk !== 'undefined') ?  ('hits: </br>' + genBlk + '</br>') : '') +
                        ((typeof reason !== 'undefined') ?  ('Reason: ' + '<span style="color:black">'  + reason + '</span></br>') : '') +
                        ((typeof comment !== 'undefined') ? ('Comment: ' + '<span style="color:black">'  + comment + '</span>') : '') +
                    '</span>' +
                '</div>';

            $('#hoverTooltip').remove();
            $('#page-body').append(template);
            $('#hoverTooltip').css({
                position: 'fixed',
                top: e.clientY - 20,
                left: e.clientX + 10,
                display: 'block !important'
            });
            e.path[0].addEventListener('mouseleave', function () {
                $('#hoverTooltip').hide();
            });
        }

    }
}
