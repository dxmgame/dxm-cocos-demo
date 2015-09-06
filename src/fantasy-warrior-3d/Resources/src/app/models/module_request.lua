

game.CModuleRequest = class("game.CModuleRequest")
local CModuleRequest = game.CModuleRequest

function CModuleRequest:ctor(user)
    self.user = user
    self.requesting = false;
end

function CModuleRequest:dispose()
    self.user = nil
end

function CModuleRequest:request(action, param, response_callback)

    if game.sUser.module_request.requesting==true then
        return
    end

    -- �½�һ��XMLHttpRequest����
    local xhr = cc.XMLHttpRequest:new()
    -- json��������
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    -- GET��ʽ
    xhr:open("GET", game.sAssetGlobal.url .. action ..".php?" .. param)

    local function onReadyStateChange()

        -- �������;
        self.requesting = false
        if self.request_finish_callback ~= nil then
            self.request_finish_callback()
        end

        -- ��ʾ״̬��,�ɹ���ʾ200
        if xhr.status == 200 then
            local response = xhr.response
            -- �����Ӧ����
            local response_json = json.decode(response, 1)

            -- ������
            if response_json == nil then
                -- ���������
                response_callback(-998)
                return
            end

            --[[ ���� code ��Ϊ 0 ����� ]]
            if response_json.code ~= 0 then
                response_callback(response_json.code)
                return false
            end

            -- ��������
            self:_saveData(response_json)

            -- ��Ӧ��
            local action_data = response_json["action_data"] or {}
            response_callback(0, action_data)
        else
            -- self:_OpenRewardPanel("status is error code[" .. xhr.status .. "]")
            response_callback(-999)
        end
    end

    -- ע��ű������ص�
    xhr:registerScriptHandler(onReadyStateChange)
    -- ��������
    xhr:send()

    if self.request_send_callback ~= nil then
        self.request_send_callback()
    end
    self.requesting = true
end

function CModuleRequest:_saveData(data)
    local result = data["data"]
    if type(result) ~= "table" then return false end

    if isset(result, "user") then
        self.user.data.user = result.user
    end
    if isset(result, "trees") then
        self.user.data.trees = result.trees
    end
    if isset(result, "reward_history") then
        self.user.data.reward_history = result.reward_history
    end
    if isset(result, "bag") then
        self.user.data.bag = result.bag
    end
    if isset(result, "sign_in") then
        self.user.data.sign_in = result.sign_in
    end
end

function CModuleRequest:setRequestSendCallback(callback)
    self.request_send_callback = callback
end

function CModuleRequest:setRequestFinishCallback(callback)
    self.request_finish_callback = callback
end

return CModuleRequest