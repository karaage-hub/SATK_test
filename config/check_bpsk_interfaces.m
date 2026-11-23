function check_bpsk_interfaces
%CHECK_BPSK_INTERFACES CSV、辞書、モデル端子の静的整合を確認。
% コンパイル・シミュレーション・動作規則の検証は行わない。
p = currentProject;
folder = fullfile(p.RootFolder,'docs/bpsk-demod/data');
f = readtable(fullfile(folder,'bpsk-demod-interface-fields.csv'),'TextType','string','Encoding','UTF-8');
i = readtable(fullfile(folder,'bpsk-demod-interfaces.csv'),'TextType','string','Encoding','UTF-8');
d = Simulink.data.dictionary.open(fullfile(p.RootFolder,'config/bpsk_demod_interfaces.sldd'));
s = getSection(d,'Design Data');
types = unique(f.record_type,'stable');
for k = 1:numel(types)
    b = getValue(getEntry(s,char(types(k))));
    rows = f(f.record_type == types(k),:);
    assert(isa(b,'Simulink.Bus') && numel(b.Elements)==height(rows));
    for j = 1:height(rows)
        e = b.Elements(j);
        assert(strcmp(e.Name,rows.field(j)) && strcmp(e.DataType,erase(rows.data_type(j),'complex ')));
        assert(strcmp(e.Complexity,'complex') == startsWith(rows.data_type(j),'complex '));
        if rows.dimensions(j)=="scalar", dims=1;
        else, dims=sscanf(char(erase(erase(rows.dimensions(j),'['),']')),'%d,%d')'; end
        assert(isequal(e.Dimensions,dims));
        assert(contains(string(e.Description),rows.meaning(j)));
    end
end
m = 'bpsk_demod_architecture';
if ~bdIsLoaded(m), open_system(fullfile(p.RootFolder,'models/bpsk-demod',[m '.slx'])); end
assert(strcmp(get_param(m,'DataDictionary'),'bpsk_demod_interfaces.sldd'));
ports = [find_system(m,'BlockType','Inport');find_system(m,'BlockType','Outport')];
seen = strings(0);
for k = 1:numel(ports)
    parent = get_param(ports{k},'Parent');
    if strcmp(parent,m), prefix="root"; else, prefix=string(get_param(parent,'Name')); end
    endpoint=prefix+"/"+string(get_param(ports{k},'Name'));
    hits=false(height(i),1);
    for j=1:height(i), hits(j)=any([i.source(j);split(i.destination(j),';')]==endpoint); end
    assert(any(hits),'Endpoint not in CSV: %s',endpoint);
    t=unique(i.data_type(hits)); assert(numel(t)==1);
    if any(types==t), expected="Bus: "+t; else, expected=erase(t,'complex '); end
    assert(string(get_param(ports{k},'OutDataTypeStr'))==expected,'Type mismatch: %s',endpoint);
    if ~any(types==t)
        assert(strcmp(get_param(ports{k},'SignalType'),'complex')==startsWith(t,'complex '));
        assert(strcmp(get_param(ports{k},'PortDimensions'),'1'));
    end
    seen(end+1)=endpoint; %#ok<AGROW>
end
for j=1:height(i)
    assert(all(ismember([i.source(j);split(i.destination(j),';')],seen)));
end
fprintf('PASS: %d Bus types, %d fields, %d endpoints, %d interfaces. Static checks only.\n',numel(types),height(f),numel(ports),height(i));
end
