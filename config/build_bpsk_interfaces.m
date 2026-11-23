function build_bpsk_interfaces
%BUILD_BPSK_INTERFACES CSV正本からインターフェース辞書を再生成する。
% 既存の無関係な辞書エントリは保持する。モデルの端子設定は変更しない。
p = currentProject;
root = p.RootFolder;
f = readtable(fullfile(root,'docs/bpsk-demod/data/bpsk-demod-interface-fields.csv'),'TextType','string','Encoding','UTF-8');
file = fullfile(root,'config/bpsk_demod_interfaces.sldd');
if isfile(file), d = Simulink.data.dictionary.open(file);
else, d = Simulink.data.dictionary.create(file); end
section = getSection(d,'Design Data');
types = unique(f.record_type,'stable');
for k = 1:numel(types)
    rows = f(f.record_type == types(k),:);
    bus = Simulink.Bus;
    bus.Description = char(types(k) + " | draft | CSV: bpsk-demod-interface-fields.csv; 動作契約: 仕様書5章");
    elements = repmat(Simulink.BusElement,height(rows),1);
    for j = 1:height(rows)
        e = Simulink.BusElement;
        e.Name = char(rows.field(j));
        e.DataType = char(erase(rows.data_type(j),'complex '));
        if startsWith(rows.data_type(j),'complex '), e.Complexity = 'complex'; end
        if rows.dimensions(j) == "scalar", e.Dimensions = 1;
        else, e.Dimensions = sscanf(char(erase(erase(rows.dimensions(j),'['),']')),'%d,%d')'; end
        assert(~isempty(e.Dimensions),'Invalid dimensions');
        % sample/bit等は物理単位ではないためUnitに設定せず説明に保存。
        e.Description = char(rows.meaning(j) + " | 単位/意味: " + rows.unit(j) + " | " + rows.status(j));
        elements(j) = e;
    end
    bus.Elements = elements;
    name = char(types(k));
    if exist(section,name), setValue(getEntry(section,name),bus);
    else, addEntry(section,name,bus); end
end
saveChanges(d);
fprintf('Saved %d Bus types, %d fields: %s\n',numel(types),height(f),file);
end
