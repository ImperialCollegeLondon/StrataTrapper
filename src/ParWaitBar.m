classdef ParWaitBar < handle
    %PARWAITBAR Summary of this class goes here
    %   waitbar wrapper to update progress of parallel loop

    properties
        state
        final_state
        wb
        start_time
        stop_button
        last_reported_state
        last_reported_time
        elapsed
    end

    methods
        function [self, update_queue] = ParWaitBar(max_iterations)
            self.final_state = max_iterations;
            update_queue = parallel.pool.DataQueue;
            
            if self.final_state == 0
                return;
            end
            
            self.state = 0;
            
            self.wb = waitbar(self.state, sprintf('%u cells to upscale', self.final_state), ...
                'Name', 'StrataTrapper');
            self.start_time = tic();

            self.last_reported_state = self.state;
            self.last_reported_time = 0;

            afterEach(update_queue,@(~) self.update());
        end

        function flag = enabled(self)
            flag = self.final_state > 0;
        end

        function update(self)
            if self.final_state == 0
                return;
            end
            self.state = self.state + 1;
            self.elapsed = toc(self.start_time);

            time_to_report = (self.elapsed - self.last_reported_time) > 1;
            state_to_report = (self.state - self.last_reported_state) > self.final_state * 0.01;

            if ~(time_to_report || state_to_report)
                return;
            end

            self.last_reported_state = self.state;
            self.last_reported_time = self.elapsed;

            pace_integral = self.elapsed / self.state;
            eta_estimate = (self.final_state - self.state) * pace_integral;
            eta = duration(seconds(eta_estimate), 'Format', 'hh:mm:ss');
            elapsed_str = duration(seconds(self.elapsed), 'Format', 'hh:mm:ss');
            message = sprintf('%u/%u cells upscaled\n passed: %s | ETA: %s', ...
                self.state, self.final_state, elapsed_str, eta);
           
            if ~isvalid(self.wb)
                return;
            end
            waitbar(self.state / self.final_state, self.wb, message);
        end

        function finish(self)
            if self.final_state == 0
                return;
            end
            elapsed_str = duration(seconds(self.elapsed), 'Format', 'hh:mm:ss');
            message = sprintf('%u cells upscaled\n in %s', self.state, elapsed_str);
            if ~isvalid(self.wb)
                return;
            end
            waitbar(1, self.wb, message);
        end

        function delete(self)
            finish(self);
        end
    end
end

    % stop_button = uicontrol('Style', 'pushbutton', 'String', 'Stop', ...
    %     'Parent', wb, ... % Set the button's parent to the waitbar figure
    %     'Position', [10, 10, 50, 20], ... % Restore the previous position
    %     'Callback', @(~, ~) send(stop_signal, true)); % Send stop signal

% stop_signal = parallel.pool.DataQueue;
% stop_flag = StopFlag(); % Use a handle class for the stop flag
% afterEach(stop_signal, @(~) stop_flag.raise()); % Update the stop flag
