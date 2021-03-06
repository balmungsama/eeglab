% eeg_helpadmin.m() - Help file for EEGLAB

function noname();

command = { ...
'pophelp(''eeg_checkset.m'');' ...
'pophelp(''eeg_eval.m'');' ...
'pophelp(''eeg_global.m'');' ...
'pophelp(''eeg_helpadmin.m'');' ...
'pophelp(''eeg_helphelp.m'');' ...
'pophelp(''eeg_helpmenu.m'');' ...
'pophelp(''eeg_helppop.m'');' ...
'pophelp(''eeg_helpsigproc.m'');' ...
'pophelp(''eeg_helpstudy.m'');' ...
'pophelp(''eeg_hist.m'');' ...
'pophelp(''eeg_options.m'');' ...
'pophelp(''eeg_optionsbackup.m'');' ...
'pophelp(''eeg_readoptions.m'');' ...
'pophelp(''eeg_retrieve.m'');' ...
'pophelp(''eeg_store.m'');' ...
'pophelp(''eegh.m'');' ...
'pophelp(''eeglab_error.m'');' ...
'pophelp(''eeglab_exec.m'');' ...
'pophelp(''eeglab_options.m'');' ...
'pophelp(''errordlg2.m'');' ...
'pophelp(''finputcheck.m'');' ...
'pophelp(''gethelpvar.m'');' ...
'pophelp(''getkeyval.m'');' ...
'pophelp(''gettext.m'');' ...
'pophelp(''inputdlg2.m'');' ...
'pophelp(''inputgui.m'');' ...
'pophelp(''is_sccn.m'');' ...
'pophelp(''listdlg2.m'');' ...
'pophelp(''pop_delset.m'');' ...
'pophelp(''pop_editoptions.m'');' ...
'pophelp(''pop_rejmenu.m'');' ...
'pophelp(''pop_stdwarn.m'');' ...
'pophelp(''pophelp.m'');' ...
'pophelp(''questdlg2.m'');' ...
'pophelp(''supergui.m'');' ...
'pophelp(''vararg2str.m'');' ...
'pophelp(''warndlg2.m'');' ...
};
text = { ...
'eeg_checkset.m' ...
'eeg_eval.m' ...
'eeg_global.m' ...
'eeg_helpadmin.m' ...
'eeg_helphelp.m' ...
'eeg_helpmenu.m' ...
'eeg_helppop.m' ...
'eeg_helpsigproc.m' ...
'eeg_helpstudy.m' ...
'eeg_hist.m' ...
'eeg_options.m' ...
'eeg_optionsbackup.m' ...
'eeg_readoptions.m' ...
'eeg_retrieve.m' ...
'eeg_store.m' ...
'eegh.m' ...
'eeglab_error.m' ...
'eeglab_exec.m' ...
'eeglab_options.m' ...
'errordlg2.m' ...
'finputcheck.m' ...
'gethelpvar.m' ...
'getkeyval.m' ...
'gettext.m' ...
'inputdlg2.m' ...
'inputgui.m' ...
'is_sccn.m' ...
'listdlg2.m' ...
'pop_delset.m' ...
'pop_editoptions.m' ...
'pop_rejmenu.m' ...
'pop_stdwarn.m' ...
'pophelp.m' ...
'questdlg2.m' ...
'supergui.m' ...
'vararg2str.m' ...
'warndlg2.m' ...
};
textgui( text, command,'fontsize', 15, 'fontname', 'times', 'linesperpage', 18, 'title',strvcat( 'Admin functions', '(Click on blue text for help)'));
icadefs; set(gcf, 'COLOR', BACKCOLOR);h = findobj('parent', gcf, 'style', 'slider');set(h, 'backgroundcolor', GUIBACKCOLOR);return;
